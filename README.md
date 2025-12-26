# dotfiles

This repository contains my dotfiles, and a massive automation system for installing and managing my dotfiles, software, and servers.

Some important folders

* `docs/`: Contains conventions, manual installation steps, and noteworthy pitfalls 
* `make/`: contains Makefile-based modules for the main installation script
* `config/`: contains content copied to `~/.config`
* `cinnamon/`: Contains cinnamon-specific configuration
* `automation/`: Contains shell scripts for automated installation of some more complicated services. Some of these are used by specific parts of `make/` (largely `nova.mk`?)
* `scripts/`: Contains supporting scripts used through zsh
* `windows/`: contains Windows-specific scripts, and also the keyboard layout I use

The remaining folders contain various minor files not directly worth mentioning here. 

In addition, in my local install, `secrets/` exists. This is a remote git repo stored in my local forgejo instance. As the name suggests, it contains secrets.

> [!warning]
>
> You should not run any of the automation scripts without fully understand what they do first. They install a lot of opinionated stuff, and make decisions that I can only guarantee make sense with my specific setup. If you're interested in joinking my dotfiles, do so manually.
>
> However, running it as-is, unless you're me, is likely a bad idea, and will likely have unexpected consequences. You have been warned.

## Prerequites

From nothing, it's assumed that:

* You have an SSH key for GitHub set up
* If using the `secrets` target, you must additionally be me, and have an SSH key to forgejo as well. 
* You have cloned the repo, and have Git installed.

## Running the automation systems

There's a few main targets, and they're somewhat modular. These are:

* `home`: used for private machines
* `server`: used for servers (shock)
* `work`: used for work computers

In addition, the following non-bundled  targets exist:

* `secrets`: clones the secrets repo and runs `bootstrap.sh`. For context for anyone without access to my secrets repo, this is just a shell script in the secrets repo that copies the secret files where they need to be copied.
* `java`: installs some Java-related tooling. Ironically, java itself is not installed through this dependency, as java versions in the wild seem to be more involved than "Just install latest and call it a day". Don't you just love legacy software?

There's also `common`, which runs everything except the configuration-specific targets

## License 

See the LICENSE file for the full details. The project is licensed under the Unlicense. 

