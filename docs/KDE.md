# KDE post-setup steps

## KDE

Activate `Profile 1`. Everything else is automated.

## Plasma

Plasma itself is somewhat resistant to automation, so plasma itself has post-install steps

### Keybinds

Navigate to custom shortcuts, then edit -> import, and import each of the `.khotkeys` files in `kde/plasma`. This same routine applies to updates of keybinds, but with the added step of deleting the existing group before[^1] import.

A variant of this routine also applies to the built-in shortcuts. Navigate to shortcuts, then import scheme. KDE's builtin defaults are much weaker than those of Cinnamon, so this is a required step.

### Clipboard history

Clipboard history is enabled by default. It can be disabled via the clipboard item in the tray.

[^1]: After also works, but requires figuring out which the new version is, which may or may not be annoying depending on how long it's been since the last update.
