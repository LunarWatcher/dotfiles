# Zsh config scripts

Certain programs require PATH modifications or a script to be sourced in order to function. A chunk of these programs offer oneliners in the form of `[[ -f some/script/path ]] && source some/script/path` (or equivalent for `-d`).

The rest rather rudely require a fair bit more code. They go in this folder in wrapper scripts, so my .zshrc can use the same form for them all.

The one exception to that in this folder is `steam.zsh`, which is a utility wrapper for adding certain tools installed through steam to the path. 

Of course, the problem child that caused this folder to be added (anaconda) was also removed while making this folder, because I don't have it anywhere anymore. 

