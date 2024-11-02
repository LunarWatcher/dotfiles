# General setup

Hello me. Here we go again.

## Terminology

* Secure device: a device I have guaranteed control over, which gets full access to my infrastructure
* Insecure device: A device I don't have full control over (usually work computers) that get limited or no access to my infrastructure.

## Base setup

After installing, you need to manually install `git`, and clone the repo. If you're incuding the keychain, copy it over somehow (warpinator is strongly recommended)

> [!TIP]
> Copypasta for Debian
> ```bash
> sudo apt install git
> cd ~ && mkdir programming && cd programming
> # Variant one; insecure device
> git clone https://github.com/LunarWatcher/dotfiles
> # Variant two; secure device, keychain installed
> git clone git@github.com:LunarWatcher/dotfiles
> ```


> [!WARNING]
> Avoid using Firefox until everything has been set up, as any use of Firefox is more likely to introduce sync bugs

### Fixing `.ssh` perms

This is also available as an alias (`ssh-fixperms`) when zsh has been properly set up, but this step is required before a repo can be cloned, so the alias isn't available at the time it's required.

```bash
chmod 600 ~/.ssh/*
chmod 700 ~/.ssh
```

## Running the makefile

```bash
# For home use
make home
# For server use
make server
# For work use
make work
```

This process requires some supervision and manual input, but should Just Work:tm:.

### Extended secrets

For extended secrets, use
```
make secrets [other command, such as "home"]
```

When manually appending `secrets`, secrets are automatically sourced from `git@nova.git:LunarWatcher/secrets`.

**Secrets must be the first target!** If `secrets` isn't executed first, certain targets in the home and server configurations may fail.

> [!NOTE]
>
> `nova.git` is a new `~/.ssh/config` alias, and has (at the time of writing) not propagated to other systems. If `make secrets` fails, an outdated `.ssh` has been sourced. Note that `nova.git` is not a proper FQDN, just a `.ssh/config` alias.
>
> As a manual hack, `git clone git@git.[FQDN]:LunarWatcher/secrets` also works

### Putting out fires

The makefile isn't run often enough to hammer out every single bug. There's also changes to stuff that breaks things from time to time, as well as completely untested stuff because, surely, it's identical so it should work:tm: (and then explodes in your face because of course it does)

Do the updates on another machine, and as far as possible, try to patch exclusively via the makefile. This reduces the chance stuff gets fixed, but the exact fix isn't part of the makefile. Having a second machine is useful here

### Known bugs

* texlive gets stuck
    * Press and hold enter while it's installing. Fuck knows why it works

## Manual post-setup work

### `chsh` and relog

`chsh -s $(which zsh)`, then relog. 

Not currently handled by the makefile, not sure why. It is what it is.

### Cinnamon

Not all cinnamon settings are copied (unfortunately). This is a work in progress.

Things to update:

* Themes
* Time widget:
    * Time format: `%A, %B %e, %H:%M:%S`
    * Enable week numbers
* Wallpaper &lt;3
* Language: Set language and time format to british, and region should correctly default to norwegian and not be an issue. (Not sure if there's a way to get this right during install, english just seems to default to 'murican. might be missing an option, but I don't install often enough to tell)
* Sounds need to be disabled 
* Window  Tiling > Maximise, instead of tile, when dragging a window to the top edge

### Firefox

I love Firefox, but holy fuck is the sync process messy. Things that need manual fixing (and that aren't obvious):

* Container tabs has its own separate sync system, and requires logging into your FF account separately, because fuck you
* The theme is usually never synced, and occasionally clears the theme from all other devices. The theme needs to be reset, possibly on all devices. I'm not sure why this happens
* Plugins need to be re-pinned, and bloatware needs to be unpinned
* The search engine needs to be switched from DDG back to Kagi, because the DDG plugin *forcibly* changes the search engine away from Kagi when it eventually syncs. Fuck you, DDG; I just want the email aliases, not the search engine.
* uBlock, Kagi, and possibly one other plugin I'm forgetting right now needs to be manually enabled in incognito tabs
* Non-standard uBlock blocklists need to be enabled. The following non-included filter lists need to be added:
    ```
    https://raw.githubusercontent.com/LunarWatcher/uBlock-blocklists/master/Blocklist.txt
    https://raw.githubusercontent.com/LunarWatcher/uBlock-blocklists/master/anti-ai.txt
    https://raw.githubusercontent.com/LunarWatcher/uBlock-blocklists/master/anti-ai-nuclear.txt
    ```

### Gnome terminal (and others)

* Set the font to SauceCodePro
* Set the colourscheme to light mode
    * In newer versions, Gnome ships its own terminal scheme that seems to work fine. No need ot manually install papercolour anymore
* Disable the menubar (Gnome: Settings -> General -> Show menubar by default in new terminals)

### Syncthing

> [!WARNING]
> Before proceeding, make sure you change the default folder to `~/Documents/Syncthing/`, and `mkdir ~/Documents/Syncthing`

First, auto-startup:
```
systemctl enable syncthing@olivia.service
systemctl start syncthing@olivia.service
```

> [!TIP]
>
> If syncthing was started outside systemd, it needs to be shut down before taking the above steps. Otherwise, `start` will fail. This is a one-time problem, however.

On secure machines: folders need to be shared. Adding nova as an introducer should automatically get everything up and running. Note that some folders on `nova` have passwords that are stored in Bitwarden.

### Git 

Remember to set `user.name` and `user.email`. The `.gitconfig` is not synced to avoid problems with work devices (plus, it's a worthless file)

### Laptops

* Battery settings need to be changed so stuff doesn't immediately time out

### Misc. software

* AutoKey needs to be added to startup apps (there's a setting for it in autokey; use it)
* A DAV account needs to be connected to the OS
    * Calendar should pick up on this automatically, but until Endeavour works, the TODO thing needs to be manually set up with the DAV server as well
