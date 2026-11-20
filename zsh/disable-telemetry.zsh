# This script sets a bunch of telemetry-related toggles, because being open-source (especially in the JS ecosystem for
# some reason) now means lots of telemetry.
# I fucking hate the npm ecosystem so much for shit like this

export NEXT_TELEMETRY_DISABLED=1
export NUXT_TELEMETRY_DISABLED=1
export EXPO_NO_TELEMETRY=1
export BETTER_AUTH_TELEMETRY=0
export ASTRO_TELEMETRY_DISABLED=1
export TURBO_TELEMETRY_DISABLED=1
export STORYBOOK_DISABLE_TELEMETRY=true
# I currently don't use this, but might end up being forced to at work
# (hopefully not, early adopting hype software has not worked out well so far; see deno, which was killed by god damn
# cloudflare)
export MISE_USE_VERSIONS_HOST_TRACK=false

# I don't think I'll never need this, but it's on telemetry lists, so might as well while I'm at it
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Fuck you microslop
# `gh` also supports the DO_NOT_TRACK variable, but adding it for good measure
export GH_TELEMETRY=false

export PROTON_PASS_DISABLE_TELEMETRY=1

export REDGATE_DISABLE_TELEMETRY=true

# Used by a bunch of hashicorp products:
# https://checkpoint.hashicorp.com/
export CHECKPOINT_DISABLE=1

# https://donottrack.sh/
# Not super widely used, but a chunk of tools do use it
export DO_NOT_TRACK=1

if command go >/dev/null 2>&1; then
    go telemetry off >/dev/null 2>&1
fi
