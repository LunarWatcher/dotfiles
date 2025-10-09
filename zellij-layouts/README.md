# Zellij layouts

This folder contains standard layouts for [zellij](https://zellij.dev). In my workflow, they're used with projects that manage to follow various conventions, and just don't need anything special to run. These also serve as templates for more specific implementations.

## Notes to self 

> Zellij layout files can include any configuration that can be defined in a Zellij configuration file. - https://zellij.dev/documentation/layouts-with-config.html

And because environment variables aren't automatically and implicitly forwarded, this means `env` can be added there. However, this does not help with dynamic environment variables, as these are still not implemented:

* https://github.com/zellij-org/zellij/issues/2639
* https://github.com/zellij-org/zellij/issues/4240

However, it does appear that the variables are forwarded:
* https://github.com/zellij-org/zellij/issues/1531

So actually unabandoning planning umbra might be a good idea. Letting it manage the environment and many pipeline actions, then letting zellij deal with layouts and delegating to the inner pipeline might make sense. This does mean there's some nested bullshit, but I don't inherently see a problem with that.

It's also much more viable to do so, even though it does result in non-unified config. There is also a pipeline thing in zellij itself, but I don't think I want to use it. It's another dependency and not an official plugin, so let's try avoiding another [#25](https://github.com/LunarWatcher/dotfiles/issues/25)
