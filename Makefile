help:
	@echo "Supported targets:"
	@echo "dotfiles - install dotfiles only"
	@echo "common - install dotfiles and system deps"
	@echo "home - same as common with additional software"
	@echo "server - same as common with additional software"
	@echo "secrets - used alongside the other options to source secrets"

ifeq ($(OS),Windows_NT)
currOs := win
else
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
currOs := linux
# The distribution should be able to be portably extracted by using
# /etc/os-release
# Note that there are more steps than just parsing this file on certain
# distributions. See
# https://gist.github.com/natefoo/814c5bf936922dad97ff
# for more details and alternatives
currDist := $(shell cat /etc/os-release | sed -n 's/^ID=\(.*\)$$/\1/p')
isWSL := $(shell uname -r | grep -q "WSL2" && echo "WSL2" || echo "NO")

$(info -- WSL detected? $(isWSL))
endif
ifeq ($(UNAME_S),Darwin)
currOs := macos
endif
endif

host := $(shell hostname)

$(info -- Running on host $(host))
$(info -- Detected OS $(currOs))
$(info -- Detected distribution $(currDist))
DEPENDENCY_TARGETS =
DOTFILE_TARGETS =
SOFTWARE_TARGETS =
CLEANUP_TARGETS =

# Group vars
HOME_TARGETS =
SERVER_TARGETS =
WORK_TARGETS =
NON_SERVER_TARGETS =

ifeq ($(isWSL),WSL2)
$(info -- Loading WSL shit)
include make/special/wsl2.mk
endif
# First, check the OS
ifeq ($(currOs),linux)
$(info -- Linux identified)
# On Linux, we pay more attention to the distro than the OS
# Note that this is, strictly speaking, an implementation detail
ifeq ($(currDist),linuxmint)
$(info -- Loading Mint-specific stuff)
include make/distros/mint.mk
# TODO: maybe worth setting this up to load anywhere with flatpak?
include make/packages/flatpak.mk
endif # mint

ifeq ($(currDist),debian)
$(info -- Loading Debian (non-derivative\)-specific stuff)
include make/distros/debian.mk

endif # debian

ifeq ($(currDist),ubuntu)
$(info -- Loading ubuntu-specific stuff)
include make/distros/ubuntu.mk
endif # ubuntu

ifeq ($(currDist),arch)
$(info -- Loading arch-specific stuff)
include make/distros/arch.mk
endif #arch

endif # linux

ifeq ($(currOs),win)
endif
ifeq ($(currOs),macos)
endif

-include make/hosts/$(host).mk

include make/dotfiles/common.mk
ifeq ($(isWSL),NO)
$(info -- Loading KDE extensions)
include make/dotfiles/kde.mk
endif

dependencies: $(DEPENDENCY_TARGETS);
dotfiles: $(DOTFILE_TARGETS);
software: $(SOFTWARE_TARGETS);
cleanup: $(CLEANUP_TARGETS);

core: dependencies dotfiles software
common: core cleanup

home: core $(HOME_TARGETS) $(NON_SERVER_TARGETS) cleanup
server: core $(SERVER_TARGETS) cleanup
work: core $(WORK_TARGETS) $(NON_SERVER_TARGETS) cleanup

secrets:
	git clone git@nova.git:LunarWatcher/secrets
	./secrets/bootstrap.sh

include make/packages/intellij.mk
java: jetbrains-toolbox

.PHONY: home server common core cleanup software dotfiles dependencies

# vim:autoindent:noexpandtab:tabstop=4:shiftwidth=4
