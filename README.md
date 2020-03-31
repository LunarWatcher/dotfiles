# dotfiles

## Note: 

This project is actively being rebuilt due to real Linux installs that've caused me to get annoyed at certain setup actions. Further changes and documentation coming soon:tm:.

## .vimrc

### Notes

* Out of the box, the Python paths are set to python2 and python3. This actually works perfectly fine if an executable called python2 and one called python3 can be found in the path. If they don't, you can either symlink them (copying is not recommended), or change the paths to use the full path.
* To use the devicons plugin, a [patched Nerd Font](https://github.com/ryanoasis/nerd-fonts) is required. Linux is also a requirement, due to a bug that prevents use on Windows. (If you're running Windows, it falls back to the Powerline-patched Source Code Pro). Fonts patched with only Powerline symbols will not work. If you don't have one, and won't/can't install one, I highly suggest you remove the plugin. (Remember to change the font)

## About init.sh 

Init.sh is a bootstrapping script, and configures entire installs. Dotfiles can be copied over with `./init.sh --dotfiles`. There's a bunch of options that enable the script to do a hell of a lot more than just copying over dotfiles. 

But beware; this script has very few prompts. Read over it and understand it before you run it. You might end up with behavior you didn't expect. If in doubt, you can always copy the files manually, or just parts if that's more your thing. 

# License 

See the LICENSE file for the full details. The project is licensed under the Unlicense. 

