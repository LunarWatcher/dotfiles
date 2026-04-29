#!/usr/bin/lua5.4

local moonsys = require("moonbeam.system");
local moonjson = require("moonbeam.json");

local function copy(data)
    local xclip = moonsys.process({
            "/usr/bin/xclip",
            "-selection", "clipboard",
            "-rmlastnl",
            "-in"
    });

    xclip:write(data)
    xclip:closeStdin();
    if xclip:block() ~= 0 then
        print("No item selected. Aborting")
        print("stdout:\n" .. xclip:readStdout())
        print("stderr:\n" .. xclip:readStderr())
        os.exit(1)
    end
    print("Copied to clipboard!")
    -- print("data: " .. data)
end


local function locateProtonPass()
    local proc = moonsys.process({
            "/usr/bin/bash", "-c", "which pass-cli"
    })
    if proc:block() ~= 0 then
        print("Failed to resolve proton pass path")
        os.exit(1);
    end
    return proc:readStdout():gsub("\n", "")
end

local function testLogin(protonPass)
    local protonTest = moonsys.process({
            protonPass,
            "test"
    })

    if protonTest:block() ~= 0 then
        print("Proton pass error:")
        print("stdout:\n" .. protonTest:readStdout())
        print("stderr:\n" .. protonTest:readStderr())

        print("Did you reboot and forget to relog?")
        os.exit(1)
    end
end

local function getVaultContent(protonPass, vaultName)
    local vaultContentsProc = moonsys.process({
            protonPass,
            "item",
            "list",
            vaultName,
            "--output", "json",
            "--filter-state", "active"
    });
    if vaultContentsProc:block() ~= 0 then
        print("Failed to read contents")
        print("stdout:\n" .. vaultContentsProc:readStdout())
        print("stderr:\n" .. vaultContentsProc:readStderr())
        os.exit(1)
    end

    return moonjson.parse(vaultContentsProc:readStdout())
end

local function parseVault(vault)
    local selectableContent = {}

    for _, it in pairs(vault["items"]) do
        local passwords = { }
        local items = 0

        if it.content["content"] ~= nil and it.content.content["Login"] ~= nil then
            passwords[it.content.title] = {
                ["password"] = it.content.content.Login.password,
                ["login"] = (it.content.content.Login.username ~= "") and it.content.content.Login.username
                    or it.content.content.Login.email,
                ["title"] = "Login creds"
            }
            items = items + 1
        end

        for _, extras in pairs(it.content.extra_fields) do
            if extras.content["Hidden"] ~= nil then
                passwords[extras.name] = {
                    ["password"] = extras.content.Hidden,
                    ["login"] = "",
                    ["title"] = extras.content.Hidden.title
                };
                items = items + 1
            end
        end

        if items == 0 then goto continue end

        table.insert(selectableContent, {
            ["id"] = it.id,
            ["title"] = it.content.title,
            ["passwords"] = passwords
        })

        ::continue::
    end

    return selectableContent
end

local function pickTopLevelItem(vaultName, selectableContent)
    local selectItem = moonsys.process({
            "/usr/bin/rofi",
            "-dmenu",
            "-p", "Select secret",
            "-mesg", "Selecting from vault " .. vaultName,
            "-i",
            "-sep", "$",
            "-format", "i",
            "-eh", "1",
            "-sync"
    });

    for _, content in pairs(selectableContent) do
        selectItem:write(
            content.title .. "$"
        )
    end

    selectItem:closeStdin()
    if selectItem:block() ~= 0 then
        print("No item selected. Aborting")
        print("stdout:\n" .. selectItem:readStdout())
        print("stderr:\n" .. selectItem:readStderr())
        os.exit(1)
    end

    local item = selectItem:readStdout()
    if item == "" then
        print("No item selected. Aborting")
        print("stdout:\n" .. selectItem:readStdout())
        print("stderr:\n" .. selectItem:readStderr())
        os.exit(1)
    end

    return tonumber(item)
end
local function pickItemTypeAndCopy(protonPass, vaultName, selectedItem)

    local selectType = moonsys.process({
            "/usr/bin/rofi",
            "-dmenu",
            "-p", "Select secret",
            "-mesg", "Selecting from item " .. selectedItem.title,
            "-i",
            "-sep", "$",
            "-format", "i",
            "-eh", "1",
            "-sync"
    });

    local options = {}
    for _, section in pairs(selectedItem.passwords) do
        if section.password ~= "" then
            selectType:write(
                section.title .. " (Password)$"
            )

            table.insert(options, section.password)
        end
        if section.login ~= "" then
            selectType:write(
                section.title .. " (Username/email)$"
            )

            table.insert(options, section.login)
        end
    end

    selectType:write("TOTP (noop if not 2FA-enabled)")

    selectType:closeStdin()
    if selectType:block() ~= 0 then
        print("No item selected. Aborting")
        print("stdout:\n" .. selectType:readStdout())
        print("stderr:\n" .. selectType:readStderr())
        os.exit(1)
    end

    local result = selectType:readStdout()
    if result == "" then
        print("No item selected. Aborting")
        print("stdout:\n" .. selectType:readStdout())
        print("stderr:\n" .. selectType:readStderr())
        os.exit(1)
    end

    local index = tonumber(result)

    if index == #options then
        -- TOTP
        local getTotp = moonsys.process({
                protonPass,
                "item",
                "totp",
                "--vault-name", vaultName,
                "--item-id", selectedItem.id,
                "--field", "totp",
                "--output", "json"
        });
        if getTotp:block() ~= 0 then
            print("No item selected. Aborting")
            print("stdout:\n" .. getTotp:readStdout())
            print("stderr:\n" .. getTotp:readStderr())
            os.exit(1)
        end

        local raw = getTotp:readStdout():gsub("\n", "")
        if raw == "" then
            print("Failed to read totp")
            print("stdout:\n" .. getTotp:readStdout())
            print("stderr:\n" .. getTotp:readStderr())
            os.exit(1)
        end

        local code = moonjson.parse(raw)["totp"]
        copy(code)
    else
        copy(options[index + 1])
    end

end

local function main()

    local protonPass = locateProtonPass()
    print("Using pass-cli at " .. protonPass)
    local vaultName = os.getenv("LIVI_PASS_VAULT") or "Work";
    print("Using vault " .. vaultName)

    testLogin(protonPass)
    local vault = getVaultContent(protonPass, vaultName)
    local selectableContent = parseVault(vault)

    -- +1 because lua is 1-indexed and rofi is not
    local selectedItem = selectableContent[
        pickTopLevelItem(vaultName, selectableContent) + 1
    ]
    pickItemTypeAndCopy(protonPass, vaultName, selectedItem)

end

main()
