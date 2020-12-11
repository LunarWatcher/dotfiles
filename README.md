# dotfiles

## Note: 

This project is actively being rebuilt due to real Linux installs that've caused me to get annoyed at certain setup actions. Further changes and documentation coming soon:tm:.

## .vimrc
Compatibility: assume latest Vim. 

As you can see, my Makefile has a target for vim that compiles Vim, so I have no reason to stay backwards-compatible. I'll update if I have to, and I can do it in 2 minutes or less on my current hardware.

### Notes

* Out of the box, the Python paths are set to python2 and python3. This actually works perfectly fine if an executable called python2 and one called python3 can be found in the path. If they don't, you can either symlink them (copying is not recommended), or change the paths to use the full path.
* To use the devicons plugin, a [patched Nerd Font](https://github.com/ryanoasis/nerd-fonts) is required. Linux is also a requirement, due to a bug that prevents use on Windows. (If you're running Windows, it falls back to the Powerline-patched Source Code Pro). Fonts patched with only Powerline symbols will not work. If you don't have one, and won't/can't install one, I highly suggest you remove the plugin. (Remember to change the font)

# Makefile

This dotfile repo bases itself on makefiles. It should take care of all the relevant dependencies. Note that the files themselves assume the distro is Debian-based (for access to `apt`).

TODO: write a list of tasks

# License 

See the LICENSE file for the full details. The project is licensed under the Unlicense. 

