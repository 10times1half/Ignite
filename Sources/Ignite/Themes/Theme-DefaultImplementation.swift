//
// Theme-DefaultImplementation.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] syntaxHighlighterTheme 기본값 제거
//

/// Bootstrap 기본 테마 값을 제공하는 기본 구현
public extension Theme {
    var accent: Color {
        Color(red: 13, green: 110, blue: 253)
    }

    var secondaryAccent: Color {
        Color(red: 108, green: 117, blue: 125)
    }

    var success: Color {
        Color(red: 25, green: 135, blue: 84)
    }

    var info: Color {
        Color(red: 13, green: 202, blue: 240)
    }

    var warning: Color {
        Color(red: 255, green: 193, blue: 7)
    }

    var danger: Color {
        Color(red: 220, green: 53, blue: 69)
    }

    var offWhite: Color {
        Color(red: 248, green: 249, blue: 250)
    }

    var offBlack: Color {
        Color(red: 33, green: 37, blue: 41)
    }

    var primary: Color {
        colorScheme == .dark ?
        Color(hex: "#dee2e6") :
        Color(hex: "#212529")
    }

    var emphasis: Color {
        colorScheme == .dark ?
        Color(hex: "#ffffff") :
        Color(hex: "#000000")
    }

    var secondary: Color {
        colorScheme == .dark ?
        Color(red: 222, green: 226, blue: 230, opacity: 75%) :
        Color(red: 33, green: 37, blue: 41, opacity: 75%)
    }

    var tertiary: Color {
        colorScheme == .dark ?
        Color(red: 222, green: 226, blue: 230, opacity: 50%) :
        Color(red: 33, green: 37, blue: 41, opacity: 50%)
    }

    var background: Color {
        colorScheme == .dark ?
        Color(hex: "#212529") :
        Color(hex: "#ffffff")
    }

    var secondaryBackground: Color {
        colorScheme == .dark ?
        Color(hex: "#343a40") :
        Color(hex: "#e9ecef")
    }

    var tertiaryBackground: Color {
        colorScheme == .dark ?
        Color(hex: "#2b3035") :
        Color(hex: "#f8f9fa")
    }

    var border: Color {
        colorScheme == .dark ?
        Color(hex: "#495057") :
        Color(hex: "#dee2e6")
    }

    var link: Color {
        colorScheme == .dark ?
        Color(hex: "#6ea8fe") :
        Color(hex: "#0d6efd")
    }

    var hoveredLink: Color {
        colorScheme == .dark ?
        Color(hex: "#9ec5fe") :
        Color(hex: "#0a58ca")
    }

    // 링크 스타일
    var linkDecoration: TextDecoration { .underline }

    // 폰트
    var monospaceFont: Font { .default }
    var font: Font { .default }

    // 폰트 크기
    var rootFontSize: LengthUnit { .default }
    var bodyFontSize: ResponsiveValues { .default }
    var inlineCodeFontSize: LengthUnit { .default }
    var codeBlockFontSize: LengthUnit { .default }

    // 줄 높이
    var lineSpacing: LengthUnit { .default }

    // 제목 크기
    var h1Size: ResponsiveValues { .default }
    var h2Size: ResponsiveValues { .default }
    var h3Size: ResponsiveValues { .default }
    var h4Size: ResponsiveValues { .default }
    var h5Size: ResponsiveValues { .default }
    var h6Size: ResponsiveValues { .default }

    // 제목 속성
    var headingFont: Font { .default }
    var headingFontWeight: FontWeight { .default }
    var headingLineSpacing: LengthUnit { .default }

    // 하단 여백
    var headingBottomMargin: LengthUnit { .default }
    var paragraphBottomMargin: LengthUnit { .default }

    // 브레이크포인트
    var breakpoints: ResponsiveValues { .default}

    // 최대 너비
    var siteWidth: ResponsiveValues { .default }
}

public extension Theme {
    /// 타입명에서 "Theme" 단어를 제거한 이름
    var name: String {
        Self.baseName.titleCase()
    }
}

extension Theme {
    /// 타입명에서 파생된 고유 식별자
    static var idPrefix: String {
        Self.baseName
            .kebabCased()
            .lowercased()
    }

    /// colorScheme에 따라 "-light" 또는 "-dark"를 붙인 고유 식별자
    var cssID: String {
        let baseID = Self.idPrefix
        switch colorScheme {
        case .light where
            baseID != "light" &&
            Self.self != DefaultLightTheme.self &&
            Self.self != AutoTheme.self:
            return baseID + "-light"
        case .dark where
            baseID != "dark" &&
            Self.self != DefaultDarkTheme.self:
            return baseID + "-dark"
        default: return baseID
        }
    }
}

fileprivate extension Theme {
    static var baseName: String {
        let name = switch Self.self {
        case is DefaultDarkTheme.Type: "dark"
        case is DefaultLightTheme.Type: "light"
        case is AutoTheme.Type: "auto"
        default: String(describing: Self.self)
        }

        return name.replacingOccurrences(of: "Theme", with: "")
    }
}
