# WSL bullshittery 

## Windows/WSL performance

Despite Microsoft's claims to the contrary, Windows and WSL do not mix, and doing so is a terrible diea. An arguably critical bug absolutely tanks the filesystem performance when calling the native Windows filesystem from WSL. This bug was reported in 2019, was followded up briefly in 2020, and was never fixed[^2][^3]. 

Git, building, and many other operations are so slow they're functionally unusable on bigger projects. Save yourself the trouble, don't mix Windows and WSL.

The only thing WSL2 has going for it is that it partly acts as a VM by having GUI support. The GUI support is absolute garbage, but it works. Moving _everything_ into WSL avoids the performance-tanking filesystem barrier, at the expense of requiring more software in WSL to replace the native software that's now inoperable.

## Theming 

Title bars do not respect the GTK theme if they're run under X11[^1]. 

Some apps support Wayland, but default to X11 for reasons I assume are good. Some of these programs offer ways to configure this. Notably:

* gvim (automatic): `GVIM_ENABLE_WAYLAND=1 gvim` 
* IntelliJ (manual): `-Dawt.toolkit.name=WLToolkit` set in `idea64.vmoptions`. There's a button under the settings wheel on the start menu.

### Missing minimise/maximise buttons

gnome-tweaks -> window, enable them there. Not sure why they're disabled by default. Wayland and/or GTK is just ✨ special ✨ I guess 

## Unicode renders as bytes instead of characters

This is not a problem out of the box, but happens after running the dependency targets in the makefile.  Some part of the setup script installs something that affects the locale (possibly (probably?) `locales`), which makes anything outputting unicode suddenly incapable of printing unicode correctly. 

This is patched out automagically by newer versions of the makefile with the `wsl-unfuck-unicode` target. 


[^1]: https://www.reddit.com/r/bashonubuntuonwindows/comments/10zy4y8/gtk_theme_not_used_on_border_and_title_bar/
[^2]: https://github.com/microsoft/WSL/issues/4197
[^3]: Just to highlight how bad the performance is, I ran a script that was running for over 15 minutes, and only made it half-way before I just gave up. After migrating everything off the windows filesystem and into the WSL filesystem, the same script in the same conditions completed in 18 seconds. Estimated completion time under the Windows filesystem was 25 minutes, largely slowed down by Git operations. WSL on a Windows partition was ~83 times slower than WSL on a WSL partition (or whatever we're calling it)
