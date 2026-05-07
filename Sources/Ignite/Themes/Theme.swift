//
// Theme.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] syntaxHighlighterTheme 프로퍼티 제거 (코드 하이라이팅 미사용)
//

/// 웹사이트 테마의 시각적 스타일과 레이아웃 속성을 정의하는 프로토콜
///
/// 색상, 타이포그래피, 간격, 반응형 브레이크포인트를 포괄적으로 제어합니다.
/// Bootstrap 기본 테마 기반의 기본 구현이 포함되어 있으며, 필요에 따라 재정의할 수 있습니다.
///
/// 예시:
/// ```swift
/// struct CustomTheme: Theme {
///     static var name: String = "custom"
///     var primary: String = "#ff0000"
///     var fontFamilyBase: Font = .custom("Helvetica")
/// }
/// ```
public protocol Theme: Sendable {
    /// 이 테마의 외관 모드 (light/dark)
    var colorScheme: ColorScheme { get }

    /// 기본 브랜드 색상
    var accent: Color { get }

    /// 보조 브랜드 색상
    var secondaryAccent: Color { get }

    /// 성공 상태 색상
    var success: Color { get }

    /// 정보 상태 색상
    var info: Color { get }

    /// 경고 상태 색상
    var warning: Color { get }

    /// 위험/오류 상태 색상
    var danger: Color { get }

    /// 라이트 테마 색상
    var offWhite: Color { get }

    /// 다크 테마 색상
    var offBlack: Color { get }

    /// 본문 기본 텍스트 색상
    var primary: Color { get }

    /// 강조 콘텐츠 색상
    var emphasis: Color { get }

    /// 보조 콘텐츠 색상
    var secondary: Color { get }

    /// 3차 콘텐츠 색상
    var tertiary: Color { get }

    /// 기본 배경 색상
    var background: Color { get }

    /// 보조 배경 색상
    var secondaryBackground: Color { get }

    /// 3차 배경 색상
    var tertiaryBackground: Color { get }

    /// 기본 링크 색상
    var link: Color { get }

    /// 호버 시 링크 색상
    var hoveredLink: Color { get }

    /// 링크 텍스트 장식 스타일
    var linkDecoration: TextDecoration { get }

    /// 기본 테두리 색상
    var border: Color { get }

    /// 고정폭 폰트
    var monospaceFont: Font { get }

    /// 본문 기본 폰트
    var font: Font { get }

    /// 루트 폰트 크기 (nil이면 브라우저 기본값 사용)
    var rootFontSize: LengthUnit { get }

    /// 인라인 코드 폰트 크기
    var inlineCodeFontSize: LengthUnit { get }

    /// 코드 블록 폰트 크기
    var codeBlockFontSize: LengthUnit { get }

    /// 기본 줄 높이
    var lineSpacing: LengthUnit { get }

    /// 제목용 폰트
    var headingFont: Font { get }

    /// 제목 폰트 굵기
    var headingFontWeight: FontWeight { get }

    /// 제목 줄 높이
    var headingLineSpacing: LengthUnit { get }

    /// 제목 하단 여백
    var headingBottomMargin: LengthUnit { get }

    /// 단락 하단 여백
    var paragraphBottomMargin: LengthUnit { get }

    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>

    /// 기본 폰트 크기
    var bodyFontSize: ResponsiveValues { get }

    /// h1 폰트 크기
    var h1Size: ResponsiveValues { get }

    /// h2 폰트 크기
    var h2Size: ResponsiveValues { get }

    /// h3 폰트 크기
    var h3Size: ResponsiveValues { get }

    /// h4 폰트 크기
    var h4Size: ResponsiveValues { get }

    /// h5 폰트 크기
    var h5Size: ResponsiveValues { get }

    /// h6 폰트 크기
    var h6Size: ResponsiveValues { get }

    /// 다양한 브레이크포인트에서 사이트 콘텐츠의 최대 너비
    var siteWidth: ResponsiveValues { get }

    /// 사이트의 반응형 브레이크포인트 값
    var breakpoints: ResponsiveValues { get }
}
