# macOS app guidance

- Keep color and typography in WorkbenchAppearance. Scope accents by view so all themes remain legible.
- Keep NSTextStorage and undo history with the file buffer across editor remounts.
- Keep desktop operations on FleetBridge so local and SSH workspaces use the same backend.
- Type-check from the repo with `xcrun swiftc -typecheck -parse-as-library desktop-macos/*.swift`.
