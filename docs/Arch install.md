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

### Grub
`/etc/default/grub`:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

#### All the speed 

Add
```
cpufreq.default_governor=performance
```

#### Amd pstate

Add:
```
amd_pstate=passive amd_pstate.shared_mem=1
```

Note that on new machines, additional steps may be required to actually have it be enabled. Using `amd_pstate=active` may or may not be better

### Keyboard

As far as I can tell, there's no way to specify nodeadkeys with `loadkeys`. This is also handled separately by plasma (cinnamon's settings had no effect on it), so it needs to be set up correctly.

### Dotfiles

The rest of the automation suite is available as-is

### Nuke `gnu-free-fonts`

```
sudo pacman -Rs gnu-free-fonts
```

A font in this package acts as a fallback font that takes precedence over nicer fonts, and the font completely breaks braille. For whatever reason, specific saucecodepro fonts end up with different fallbacks? I don't understand why - maybe because the `Regular` variant doesn't directly have an equivalent in DejaVu?

There's probably a fontconfig solution here as well, but the config looks cursed and I don't really care if I can just nuke the font and have it work.

Also, note to self, the font viewer is the only reliable tool for previewing fonts. Every other input field has fallbacks, which gives the impression taht a font has characters it doesn't.

Useful forum thread: https://bbs.archlinux.org/viewtopic.php?id=284774
