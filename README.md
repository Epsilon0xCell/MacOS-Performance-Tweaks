![Introduction banner](intro-banner.png)


# MacOS-Performance-Tweaks

![Wordmark banner](banner.png)

![Scene](scene.svg)

> **Vestry notice, placed first by design:** this script deletes local Time Machine snapshots, turns Time Machine off, and clears caches, logs, and the sleep image, irreversibly. Read the warnings in this README before any instruction to run anything.

Performance tweaks for macOS, in `boost_macos_performance.sh`.


![Separator](sep-heavy.svg)

## Warning: what this script does that cannot be undone

Read this before you run anything. The script, in plain words:

- Turns off the LaunchServices quarantine prompt, the dialog macOS shows before you open an app you downloaded.
- Deletes local Time Machine snapshots.
- Turns Time Machine off, including local snapshots, so no local backup is left on the machine.
- Deletes the sleep image, language and speech data, system logs, user logs, temporary files, caches, font caches, and the contents of the Trash. None of it goes to a list first, and none of it can be brought back.
- Runs fsck -fy on the live disk the script itself is running from.

Each of those steps now stops and asks you to type YES for that step before it runs. Any other answer skips that step, and typing YES once does not approve any later step. The gates do not make the rest of the script safe. It still changes DNS servers, boot arguments, kernel limits, and power settings, and it is still a research draft.


![Separator](sep-light.svg)

## Warning: do not run this script as written

The author's own warning stands, and this pass keeps it: do not use this script, it will most likely break your system, and further research is needed before any part of it is trusted. The script deletes logs, caches, and trash contents, disables Time Machine local snapshots, runs `fsck -fy` on the live disk, changes boot arguments and kernel limits, rewrites DNS servers and network settings, and rebuilds indexes. It is preserved here as a research draft, not as a recommended tool. Nothing in this pass makes it safe to run.


![Separator](sep-heavy.svg)

## What the script does, section by section

UI and Finder tweaks (window, Dock, and Mission Control animations, Dock delay, Finder animations and warnings), Safari timing and debug menu settings, memory and power settings (`purge`, hibernation, sudden motion sensor, power nap), CPU and GPU kernel settings, disk and Time Machine commands, Mail and Photos database vacuums, network settings (including hardcoding DNS to 1.1.1.1, 1.0.0.1, 8.8.8.8, and 8.8.4.4 on Wi-Fi and disabling IPv6 on Wi-Fi), App Store, iCloud, menu bar, log and cache deletion, Spotlight rebuild, font cache clearing, and service restarts.


![Separator](sep-light.svg)

## Fixes in this pass

- Every step listed in the warning at the top now asks for a typed YES for that step before it runs: the quarantine prompt change, the Time Machine snapshot deletion, the Time Machine shutdown, each log, cache, and Trash deletion block, and the fsck run. Any other answer skips the step.
- The non-root check now exits 1 instead of exiting 0 after printing "Please run as root".
- Duplicate settings are removed: the second `expose-animation-duration`, the second `autohide-delay`, the second `NSWindowResizeTime`, the plain `IncludeInternalDebugMenu 1` (the later `-bool true` setting is kept), and the second `killall -HUP mDNSResponder`.
- Under the "Security Enhancements" heading the script used to run `spctl --master-disable`, which turns Gatekeeper off. That line now runs `spctl --master-enable`, matching the heading. Several other destructive or obsolete commands (for example `repair_packages`, `repairPermissions`, and `fsck -fy`) are left exactly as written and are covered by the warning above rather than silently rewritten.


![Separator](sep-heavy.svg)

## Verification

`bash -n boost_macos_performance.sh` passes before and after. The script was not run live in this pass, by design: running it would change a real Mac's system settings and delete files.

Files: `boost_macos_performance.sh`, `LICENSE`, `logo.png`, `banner.png`.
