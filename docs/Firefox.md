# Additional Firefox config

A bunch of FF config isn't exported via account sync, and needs to be configured manually. These are stored in the `firefox/user.js` file, which is dropped into the profile folder. For now, it's not installed automatically, as the profile names vary.

The profile folder can be found in:

* **Linux:** `~/.mozilla/firefox/`
    * ... except for Ubuntu/Snap installs, where it's at `~/snap/firefox/common/.mozilla/firefox` instead. Fuck you, Ubuntu
* **Windows:** `%APPDATA%\Mozilla\Firefox`

`.default-release` seems to generally be the right folder to use

**WARNING:** `user.js` cannot be a symbolic link. It _can_ be a link, but _not_ a symbolic link. `ln ~/programming/dotfiles/firefox/user.js {target}`. If `-s` is used, FF does not read the file.
