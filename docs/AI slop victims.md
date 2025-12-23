# AI slop victims

This list contains a list of tools I've been forced to abandon due to AI slop, along with citations. The list is in reverse chronological order by date of abandonment, and not necessarily the date at which it fell. This file exists because there's too much AI slop to keep track of manually, and I want a canonical reference in case it's needed.

Once something makes it to this list, it is not removed regardless of later backtracking. The loss of trust caused by introducing a security vulnerability-creating machine cannot be recovered even if the projects backtrack later.

## Abandoned software

### Nvm

Abandoned: 2025-12-23

* https://github.com/nvm-sh/nvm/commit/9602f4f959a9f64515fc13af2904a87dc03de685
* https://github.com/nvm-sh/nvm/commit/0215ef820352ec0a649f71ef3a1e32c21c16229f

The first commit of these contains a copilot instructions file, and is considered proof of continued planned AI slop use. Abandoned in favour of a bugfix in upm: https://github.com/LunarWatcher/upm

### Ohmyzsh

Abandoned: 2025-11-29

* https://github.com/ohmyzsh/ohmyzsh/commit/b52dd1a425e9ed9f844ba46cd27ff94a3b4949dc
* https://github.com/ohmyzsh/ohmyzsh/commit/8c5a60644a2a93fb6b7d76ec7a5598f99b426cf0

Plus confirmation that this will continue on discord. Initially abandoned outright in favour of replacement config, then the new replacement config was sourced out into a separate project: https://github.com/LunarWatcher/amethyst

## Abandoned libraries

### reflectcpp

Abandoned: 2025-10-29

Uses AI slop for reviews: https://github.com/getml/reflect-cpp/pull/563#issuecomment-3682824946

The library is still in use in a few things with the version pinned. Migration targets are nlohmann/json (most applications) and yyjson (performance-sensitive applications)

## Confirmed, but unabandonable

This list contains confirmed AI slop software I cannot get rid of for various reasons (largely due to there being no alternatives, or the risk being acceptable or otherwise mitigated). Upgrading these is significantly more risky than other software, both from the security perspective, and from general upgrade risks.

## At risk

### fnm

fnm has several open PRs that would introduce AI slop (all currently by one author):

* https://github.com/Schniz/fnm/pull/1479
* https://github.com/Schniz/fnm/pull/1474
* https://github.com/Schniz/fnm/pull/1473
* https://github.com/Schniz/fnm/pull/1472
* https://github.com/Schniz/fnm/pull/1471

These do not appear to be made by anyone on the core project, but any of them being merged would introduce AI slop. Could go either way at the time of writing. Unfortunately, the author of fnm leans towards AI slop, so the risk is far higher than I initially estimated in #31: https://github.com/Schniz/home-automation-cluster/blob/main/AGENTS.md

These are also extremely textbook slop, and were created by someone claiming to work for google, at least partly using Google's slop machine. Great sales pitch, Google.
