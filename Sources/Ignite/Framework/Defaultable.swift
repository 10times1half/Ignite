//
// Defaultable.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] HighlighterTheme extension 제거 (코드 하이라이팅 미사용)
//

/// Optional을 사용하지 않고 "기본값" 상태를 표현할 수 있는 프로토콜
protocol Defaultable {
    /// 이 값이 기본값인지 여부
    var isDefault: Bool { get }
}

extension Font: Defaultable {
    /// 기본값으로 사용되는 빈 폰트 인스턴스
    static var `default`: Font { Font(name: "", sources: []) }

    /// 이 폰트가 기본(빈) 폰트인지 여부
    var isDefault: Bool { self == .default }
}

extension Color: Defaultable {
    /// 기본값으로 사용되는 빈 색상 인스턴스
    static var `default`: Color { Color(hex: "") }

    /// 이 색상이 기본(빈) 색상인지 여부
    var isDefault: Bool { self == .default }
}

extension TextDecoration: Defaultable {
    /// 이 장식이 기본(밑줄) 장식인지 여부
    var isDefault: Bool { self == .underline }
}

extension ResponsiveValues: Defaultable where Value == LengthUnit {
    /// 이 반응형 값들이 기본(빈) 값인지 여부
    var isDefault: Bool { self == .default }

    /// 기본값으로 사용되는 빈 반응형 값 인스턴스
    static var `default`: Self {
        .init(
            small: nil,
            medium: nil,
            large: nil,
            xLarge: nil,
            xxLarge: nil
        )
    }
}
