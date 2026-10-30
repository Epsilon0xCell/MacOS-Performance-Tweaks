![Banner](banner.png)

# MacOS-Performance-Tweaks

Performance tweaks for macOS, in `boost_macos_performance.sh`.

## Warning: do not run this script as written

The author's own warning stands, and this pass keeps it: do not use this script, it will most likely break your system, and further research is needed before any part of it is trusted. The script deletes logs, caches, and trash contents, disables Time Machine local snapshots, runs `fsck -fy` on the live disk, changes boot arguments and kernel limits, rewrites DNS servers and network settings, and rebuilds indexes. It is preserved here as a research draft, not as a recommended tool. Nothing in this pass makes it safe to run.

## What the script does, section by section

UI and Finder tweaks (window, Dock, and Mission Control animations, Dock delay, Finder animations and warnings), Safari timing and debug menu settings, memory and power settings (`purge`, hibernation, sudden motion sensor, power nap), CPU and GPU kernel settings, disk and Time Machine commands, Mail and Photos database vacuums, network settings (including hardcoding DNS to 1.1.1.1, 1.0.0.1, 8.8.8.8, and 8.8.4.4 on Wi-Fi and disabling IPv6 on Wi-Fi), App Store, iCloud, menu bar, log and cache deletion, Spotlight rebuild, font cache clearing, and service restarts.

## Fixes in this pass

- The non-root check now exits 1 instead of exiting 0 after printing "Please run as root".
- Duplicate settings are removed: the second `expose-animation-duration`, the second `autohide-delay`, the second `NSWindowResizeTime`, the plain `IncludeInternalDebugMenu 1` (the later `-bool true` setting is kept), and the second `killall -HUP mDNSResponder`.
- Under the "Security Enhancements" heading the script used to run `spctl --master-disable`, which turns Gatekeeper off. That line now runs `spctl --master-enable`, matching the heading. Several other destructive or obsolete commands (for example `repair_packages`, `repairPermissions`, and `fsck -fy`) are left exactly as written and are covered by the warning above rather than silently rewritten.

## Verification

`bash -n boost_macos_performance.sh` passes before and after. The script was not run live in this pass, by design: running it would change a real Mac's system settings and delete files.

Files: `boost_macos_performance.sh`, `LICENSE`, `logo.png`, `banner.png`.
