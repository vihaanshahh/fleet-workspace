# Repository guidance

- This repository contains Fleet Workspace only. Keep the OpenCode approval preset in `integrations/opencode/agent/approval.md` intact.
- Preserve the established app bundle identifier and state locations when changing the macOS app; they keep existing preferences and history available.
- Keep macOS UI and editor work in `desktop-macos/`, Fleet runtime code in `fleet/`, and their coverage in `tests/`.
- Python tests run from `tests/` with `python3 -m unittest`; Swift checks are standalone programs compiled with the macOS SDK and the sources in `desktop-macos/`.
- `scripts/assemble-macos.py` assembles the app from staged runtime dependencies and compiles all Swift files in `desktop-macos/`.
