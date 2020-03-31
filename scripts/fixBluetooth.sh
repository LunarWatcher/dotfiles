# Patch for fixing bluetooth that doesn't want to connect.
# This isn't a guaranteed patch, but it works for my main problem 
pactl unload-module module-bluetooth-discover 
pactl load-module module-bluetooth-discover 

