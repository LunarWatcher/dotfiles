# dotfiles

## General compatibility

These dotfiles are primarily tested against Linux Mint, and occasionally against Ubuntu and debian (mostly raspbian so far). Due to work applications, WSL (Ubuntu) is also included. Most of the dependency installation relies heavily on specific system configurations, and won't work more broadly.

Windows works-ish, but it's much more unreliable, particularly with Vim. This is mainly noticeable with fzf, where the window seems to be any number of different sizes that vary between runs for no reason what so ever.

## .vimrc
Compatibility: assume latest Vim. 

As you can see, my Makefile has a target for vim that compiles Vim, so I have no reason to stay backwards-compatible. I'll update if I have to, and I can do it in 1.5 minute or less on my current hardware.

### Snippets

Up until recently, the snippets I used in Vim were kept in this repo. As of 27.08.23, they've been relocated to [a different repository](https://github.com/LunarWatcher/lunarwatcher-vim-snippets), so they're actually reusable. 

### Notes

* Out of the box, the Python paths are set to python2 and python3. This actually works perfectly fine if an executable called python2 and one called python3 can be found in the path. If they don't, you can either symlink them (copying is not recommended), or change the paths to use the full path.
* To use the devicons plugin, a [patched Nerd Font](https://github.com/ryanoasis/nerd-fonts) is required. These should now work everywhere

## Makefile

This dotfile repo bases itself on makefiles. It should take care of all the relevant dependencies. Note that the files themselves assume the distro is Debian-based (for access to `apt`).

Installing dotfiles, along with necessary dependencies can be done by running `make dotall`. For additional software, use `make all`, or just `make software`. Note that the software installed is primarily geared towards me, hence the split between dotfile installation.

Note that unless you're me, you probably don't want to do this! Extract the stuff you want, and nothing else

## License 

See the LICENSE file for the full details. The project is licensed under the Unlicense. 

