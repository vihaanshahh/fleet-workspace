import SwiftUI

enum WorkbenchTheme: String, CaseIterable, Identifiable {
    case midnight = "Midnight"
    case graphite = "Graphite"
    case daylight = "Daylight"
    case evergreen = "Evergreen"
    case parchment = "Parchment"
    case classic
    case multicolor

    var id: Self { self }
    var label: String { rawValue.capitalized }
    var scheme: ColorScheme? {
        switch self {
        case .classic, .multicolor: nil
        case .daylight, .parchment: .light
        default: .dark
        }
    }

    func palette(for appearance: ColorScheme) -> WorkbenchPalette {
        guard self == .classic || self == .multicolor else { return palette }
        var adaptive = appearance == .light ? Self.parchment.palette : Self.evergreen.palette
        if self == .multicolor {
            adaptive.multicolorAppearance = appearance
            adaptive.sidebar = appearance == .light ? 0xEBEFFA : 0x1D2336
            adaptive.panel = appearance == .light ? 0xFFFFFF : 0x25293A
            return adaptive.scoped(to: .workspace)
        }
        adaptive.selectionColor = appearance == .light ? 0xE5EBE1 : 0x333C34
        return adaptive
    }

    var palette: WorkbenchPalette {
        switch self {
        case .midnight:
            WorkbenchPalette(canvas: 0x161D29, sidebar: 0x1C2635, panel: 0x1F2B3B, border: 0x35465B,
                             ink: 0xDFE9F5, accent: 0x8CB8FF, success: 0x8BDDAD, warning: 0xF2C78A,
                             failure: 0xFDA5AA, keyword: 0xD0AEFF, literal: 0xF2B596, comment: 0x91A7BF)
        case .graphite:
            WorkbenchPalette(canvas: 0x1C1F23, sidebar: 0x23272D, panel: 0x282E35, border: 0x3D464F,
                             ink: 0xE5E9ED, accent: 0x8BDBCC, success: 0xA9DA9F, warning: 0xF2CD92,
                             failure: 0xF5A4AC, keyword: 0xBFB7F7, literal: 0xDBCE9B, comment: 0x9CA9B5)
        case .daylight:
            WorkbenchPalette(canvas: 0xFCFAF5, sidebar: 0xEFECE3, panel: 0xF5F2EA, border: 0xD9D3C7,
                             ink: 0x282A33, accent: 0x245AA0, success: 0x226541, warning: 0x86521C,
                             failure: 0xA92D46, keyword: 0x6D369A, literal: 0x913819, comment: 0x5E6A73)
        case .evergreen:
            WorkbenchPalette(canvas: 0x201F1D, sidebar: 0x292825, panel: 0x2D2C29, border: 0x484540,
                             ink: 0xEDE9E1, accent: 0xA5C5AC, success: 0xADC19F, warning: 0xDCB77F,
                             failure: 0xE1A2A0, keyword: 0xC7A6F5, literal: 0x9ECC99, comment: 0xA6A49E)
        case .classic, .multicolor:
            palette(for: .dark)
        case .parchment:
            WorkbenchPalette(canvas: 0xFBFAF7, sidebar: 0xF0EEE8, panel: 0xFFFFFF, border: 0xDCD8CE,
                             ink: 0x292825, accent: 0x38634D, success: 0x3E6A3C, warning: 0x855716,
                             failure: 0xA24744, keyword: 0x633D99, literal: 0x2E5E3B, comment: 0x626861)
        }
    }
}

enum WorkbenchArea {
    case workspace, activity, schedules, risks, code
}

struct WorkbenchPalette: Equatable {
    var canvas: UInt32
    var sidebar: UInt32
    var panel: UInt32
    let border: UInt32
    let ink: UInt32
    var accent: UInt32
    let success: UInt32
    let warning: UInt32
    let failure: UInt32
    let keyword: UInt32
    let literal: UInt32
    let comment: UInt32
    var multicolorAppearance: ColorScheme? = nil
    var selectionColor: UInt32? = nil

    func scoped(to area: WorkbenchArea) -> Self {
        guard let appearance = multicolorAppearance else { return self }
        var result = self
        let dark = appearance == .dark
        switch area {
        case .workspace:
            (result.canvas, result.accent, result.selectionColor) =
                dark ? (0x161B2A, 0xA7C7FF, 0x283B5F) : (0xF5F7FC, 0x2B55A5, 0xDBE6FB)
        case .activity:
            (result.canvas, result.accent, result.selectionColor) =
                dark ? (0x1E192A, 0xD3BEFF, 0x3B3056) : (0xF7F4FC, 0x6941A5, 0xEDE2FA)
        case .schedules, .code:
            (result.canvas, result.accent, result.selectionColor) =
                dark ? (area == .code ? 0x161B2A : 0x16242A, 0x91DCD3, 0x234542)
                     : (area == .code ? 0xF5F7FC : 0xF1F8F7, 0x12665E, 0xD8F0EB)
        case .risks:
            (result.canvas, result.accent, result.selectionColor) =
                dark ? (0x261D1B, 0xF2BE88, 0x4C3428) : (0xFAF5EE, 0x884E1B, 0xF8E7CE)
        }
        return result
    }

    var editor: Color { Color(nsColor: Self.color(canvas)) }
    var navigation: Color { Color(nsColor: Self.color(sidebar)) }
    var surface: Color { Color(nsColor: Self.color(panel)) }
    var separator: Color { Color(nsColor: Self.color(border)) }
    var tint: Color { Color(nsColor: Self.color(accent)) }
    var positive: Color { Color(nsColor: Self.color(success)) }
    var caution: Color { Color(nsColor: Self.color(warning)) }
    var negative: Color { Color(nsColor: Self.color(failure)) }
    var selection: Color { selectionColor.map { Color(nsColor: Self.color($0)) } ?? tint.opacity(0.15) }

    static func color(_ hex: UInt32) -> NSColor {
        NSColor(srgbRed: Double((hex >> 16) & 255) / 255,
                green: Double((hex >> 8) & 255) / 255,
                blue: Double(hex & 255) / 255, alpha: 1)
    }
}

enum WorkbenchCodeFont: String, CaseIterable, Identifiable {
    case system = "System Monospaced"
    case menlo = "Menlo"
    case monaco = "Monaco"

    var id: Self { self }

    func native(size: CGFloat) -> NSFont {
        (self == .system ? nil : NSFont(name: rawValue, size: size))
            ?? .monospacedSystemFont(ofSize: size, weight: .regular)
    }
}

struct WorkbenchTypography: Equatable {
    var family: WorkbenchCodeFont = .system
    var size = 13

    var native: NSFont { family.native(size: CGFloat(size)) }
    var code: Font { Font(native) }
}

private enum WorkbenchPaletteKey: EnvironmentKey {
    static let defaultValue = WorkbenchTheme.midnight.palette
}

private enum WorkbenchTypographyKey: EnvironmentKey {
    static let defaultValue = WorkbenchTypography()
}

extension EnvironmentValues {
    var workbenchPalette: WorkbenchPalette {
        get { self[WorkbenchPaletteKey.self] }
        set { self[WorkbenchPaletteKey.self] = newValue }
    }

    var workbenchTypography: WorkbenchTypography {
        get { self[WorkbenchTypographyKey.self] }
        set { self[WorkbenchTypographyKey.self] = newValue }
    }
}

struct WorkbenchAppearance: ViewModifier {
    @Environment(\.colorScheme) private var appearance
    let theme: WorkbenchTheme
    let typography: WorkbenchTypography

    func body(content: Content) -> some View {
        let palette = theme.palette(for: appearance)
        content
            .environment(\.workbenchPalette, palette)
            .environment(\.workbenchTypography, typography)
            .tint(palette.tint)
    }
}

struct WorkbenchSettings: View {
    @Environment(\.colorScheme) private var appearance
    @AppStorage("FleetTheme") private var theme = WorkbenchTheme.midnight
    @AppStorage("FleetCodeFont") private var family = WorkbenchCodeFont.system
    @AppStorage("FleetCodeFontSize") private var size = 13

    var body: some View {
        let palette = theme.palette(for: appearance)
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $theme) {
                    ForEach(WorkbenchTheme.allCases) { Text($0.label).tag($0) }
                }
                Picker("Code font", selection: $family) {
                    ForEach(WorkbenchCodeFont.allCases) { Text($0.rawValue).tag($0) }
                }
                Stepper("Code font size: \(size) pt", value: $size, in: 10...24)
            }
            Section("Preview") {
                if theme == .multicolor {
                    HStack(spacing: 8) {
                        swatch("Workspace", palette: palette)
                        swatch("Activity", palette: palette.scoped(to: .activity))
                        swatch("Schedules", palette: palette.scoped(to: .schedules))
                        swatch("Risks", palette: palette.scoped(to: .risks))
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("// Fleet Workspace").foregroundStyle(Color(nsColor: WorkbenchPalette.color(palette.comment)))
                    (Text("let ").foregroundColor(Color(nsColor: WorkbenchPalette.color(palette.keyword)))
                     + Text("workspace = ")
                     + Text("\"ready\"").foregroundColor(Color(nsColor: WorkbenchPalette.color(palette.literal))))
                        .foregroundStyle(Color(nsColor: WorkbenchPalette.color(palette.ink)))
                }
                .font(Font(family.native(size: CGFloat(size))))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(palette.editor, in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .formStyle(.grouped)
        .frame(width: 450)
        .preferredColorScheme(theme.scheme)
        .tint(palette.tint)
    }

    private func swatch(_ title: String, palette: WorkbenchPalette) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(palette.tint)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(palette.selection, in: RoundedRectangle(cornerRadius: 6))
    }
}
