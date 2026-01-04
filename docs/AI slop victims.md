# AI slop victims

This list contains a list of tools I've been forced to abandon due to AI slop, along with citations. The list is in reverse chronological order by date of abandonment, and not necessarily the date at which it fell. This file exists because there's too much AI slop to keep track of manually, and I want a canonical reference in case it's needed.

Once something makes it to this list, it is not removed regardless of later backtracking. The loss of trust caused by introducing a security vulnerability-creating machine cannot be recovered even if the projects backtrack later.

## Abandoned software

### Uptime-kuma

**Abandoned**: 2026-01-04

**Replacement:** None

* https://github.com/louislam/uptime-kuma/commit/9fb4263427f3f0216457a920d19565e31f7eb610

Also seems to correspond with a drastic spike in activity:

![Image showing uptime-kuma's pulse thing on GitHub spiking drastically some time after the introduction of the AI slop machine](.github/images/uptime-kuma-slop.png)

This seems to be caused by approving Copilot reviews directly, with some of the PRs I checked having as much as 11 commits just from Copilot's review, all default-titled by GitHub for max slop uselessness. The threat from this is high enough that uptime-kuma is dropped immediately without a replacement prepared. I was already planning to replace it, but hadn't looked into any replacements yet. It's fully JS-based, and so ridiculously heavy to run, and it's now sloppified and insecure on top of that, and therefore goes from a removal timeline of some time in 2026 to right the fuck now.

Also, [lol](https://github.com/louislam/uptime-kuma/issues/6549#issuecomment-3703357112), sure you do.

### Hugo (gohugo)

Abandoned: 2025-12-23

* https://github.com/gohugoio/hugo/blob/master/CONTRIBUTING.md#ai-assistance-notice

Also includes an AI slop machine in code review, though its current function (aside advertising Google's slop bot Gemini) is unclear. The risk is still unacceptably high. No tagged commits are included on main, but because they squash commits, it's extra hard to tell if that's the case. 

Initially planned replacement was [Zola](https://github.com/getzola/zola), but a second (unplanned) AI sweep found that [the templating engine Zola uses has an upcoming v2 with AI slop](https://github.com/Keats/tera2/pull/86), so that plan was abandoned. Website shut down on 2025-12-24 since there are no alternatives that meet all the criteria without massive amounts of refactoring for all the non-standard crap being used, since there are no standards.

Might create a replacement myself at some point after I fuck around with web servers, but this is a future me problem tentatively on the roadmap for 2026/2027.

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

### ntfy

* https://github.com/binwiederhier/ntfy-android/pull/149
* https://github.com/binwiederhier/ntfy/pull/727#discussion_r1193239268
* https://github.com/binwiederhier/ntfy/issues/1456#issuecomment-3707035246 (explicit admission)

Comparatively low-risk, largely due to the admission in the last one. Still not a fan, and still a risk, but there are no other comparable options, and Android absolutely _is_ a pain in the ass and blocks any attempts I'd have to make a comparable system (I'm unwilling to sacrifice that much time and effort on a platform that makes itself difficult to develop for).

For now, sloppified ntfy is forced to stay.

## At risk

### fnm

fnm has several open PRs that would introduce AI slop (all currently by one author):

* https://github.com/Schniz/fnm/pull/1479
* https://github.com/Schniz/fnm/pull/1474
* https://github.com/Schniz/fnm/pull/1473
* https://github.com/Schniz/fnm/pull/1472
* https://github.com/Schniz/fnm/pull/1471

These do not appear to be made by anyone on the core project, but any of them being merged would introduce AI slop. Could go either way at the time of writing. Unfortunately, the author of fnm leans towards AI slop, so the risk is far higher than I initially estimated in #31: https://github.com/Schniz/home-automation-cluster/blob/main/AGENTS.md

These PRs to fnm are also extremely textbook slop, and were created by someone claiming to work for google, at least partly using Google's slop machine. Great sales pitch, Google.
