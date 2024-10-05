import os
import subprocess
from os import walk
from os.path import join
import json
import time


# TODO: Fix
USER = os.getenv('USER')
AUTOKEY_DATA_DIR = '/home/{}/programming/dotfiles/misc/AutokeyPublic'.format(USER)


commands = []

for (dirpath, dirnames, filenames) in walk(AUTOKEY_DATA_DIR):
    # TODO: expand to script support
    configFiles = [join(dirpath, f) for f in filenames if f.endswith(('.json'))]
    for file in configFiles:
        with open(file, "r") as f:
            data = json.load(f)
            isPhrase = data["type"] == "phrase"
            
            # Avoid folder descriptors
            if not isPhrase and data["type"] != "script":
                continue
            
            abbrevs = data["abbreviation"]["abbreviations"]
            keybind = None
            if data["hotkey"]["hotKey"] is not None:
                keybind = "+".join(
                    [*data["hotkey"]["modifiers"], data["hotkey"]["hotKey"]]
                ).replace("<", "&lt;").replace(">", "&gt;")
            # Should never  happen
            if abbrevs is None and keybind is None:
                pass
        
            commands.append({
                "isPhrase": isPhrase,
                "abbrevs": abbrevs,
                "keybind": keybind,
                "title": data["description"],
                "contentPath": os.path.join(
                    os.path.dirname(file),
                    os.path.basename(file)[1:-5] + (".txt" if isPhrase else ".py")
                )
            })



stdin = []

for item in commands:
    row = item["title"]
    if item["abbrevs"] is not None and len(item["abbrevs"]):
        row += "\n<span foreground=\"#9ca0b0\">"
        row += ", ".join(item["abbrevs"])
        row += "</span>"
    if item["keybind"] is not None:
        row += "\n<span foreground=\"#9ca0b0\">"
        row += item["keybind"]
        row += "</span>"
    stdin.append(
        row
    )

query = subprocess.run(
    [
        'rofi',
        '-dmenu',
        '-p', 'Select Phrase',
        '-mesg', 'Selecting from AutokeyPublic',
        '-i',
        "-format", "i",
        "-sep", "$",
        "-eh", "2",
        "-markup-rows"
    ], 
    input='$'.join(stdin),
    text=True, 
    capture_output=True
).stdout.strip()

# If aborted, query == ""
# (yes, I could check the return codes, but this is more convenient right now, and means I don't need to search kagi for subprocess docs)
if query != "":

    idx = int(query)
    abbr = commands[idx]

    if abbr["isPhrase"]:
        with open(abbr["contentPath"]) as f:
            phrase = f.read()
            
        prev = None
        try:
            prev = clipboard.get_clipboard()
        except:
            pass
        clipboard.fill_clipboard(phrase)
        time.sleep(0.1)
        keyboard.send_keys("<ctrl>+v")
        time.sleep(0.1)
        
        if prev is not None:
            clipboard.fill_clipboard(prev)
    else:
        engine.run_script(abbr["title"])

