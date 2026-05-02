# Arch install

```bash
loadkeys no

# TODO: wifi per https://wiki.archlinux.org/title/Iwd#iwctl

pacman --sync --refresh
pacman --sync archinstall

archinstall --config-url https://codeberg.org/LunarWatcher/dotfiles/raw/branch/master/arch/core.json
```

Modify:
* Hostname
* Partitioning
* Authentication -> User account
* Profile -> Graphics driver (if not nvidia)

Then install.


## Postinstall steps

This must be done before rebooting.

AMD: `/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_pstate=passive amd_pstate.shared_mem=1"
```

## Post-postinstall steps

### Keyboard

As far as I can tell, there's no way to specify nodeadkeys with `loadkeys`. This is also handled separately by plasma (cinnamon's settings had no effect on it), so it needs to be set up correctly.

### Dotfiles

The rest of the automation suite is available as-is
