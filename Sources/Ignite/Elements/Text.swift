//
// Text.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] init(markdown:) Markdown 파싱 제거, init(markup:parser:) 삭제
//

/// 단락이나 제목 등 구조화된 텍스트 요소입니다.
/// 목록, 테이블 내부에서는 단순 문자열을 사용할 수 있지만,
/// 특정 스타일이나 크기의 텍스트가 필요할 때 `Text`를 사용합니다.
///
/// - Important: `InlineElement`만 허용하는 타입이나 `@InlineElementBuilder`에서는
///   `Text` 대신 `Span`을 사용하세요.
public struct Text: HTML, DropdownItem {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 이 텍스트에 사용할 폰트 스타일 (body, title1~6 등)
    var font = FontStyle.body

    /// 텍스트 내부에 배치할 콘텐츠
    private var content: any BodyElement

    /// 여러 단락의 Markdown 콘텐츠인지 여부
    private var isMultilineMarkdown = false

    /// 인라인 요소 빌더를 사용하여 새 `Text` 인스턴스를 생성합니다.
    /// - Parameter content: 텍스트 내부에 배치할 인라인 요소 배열
    public init(@InlineElementBuilder content: () -> any InlineElement) {
        self.content = content()
    }

    /// 하나의 인라인 요소로부터 새 `Text` 인스턴스를 생성합니다.
    public init(_ string: any InlineElement) {
        self.content = string
    }

    /// 텍스트의 최대 표시 줄 수를 설정합니다.
    /// - Parameter number: 줄 수 제한. `nil`이면 제한 없음.
    /// - Returns: 줄 수 제한이 적용된 새 `Text` 인스턴스
    public func lineLimit(_ number: Int?) -> Self {
        var copy = self
        if let number {
            copy.attributes.append(classes: "ig-line-clamp")
            copy.attributes.append(styles: .init("--ig-max-line-length", value: number.formatted()))
        } else {
            copy.attributes.append(classes: "ig-line-clamp-none")
        }
        return copy
    }

    /// "lorem ipsum" 플레이스홀더 텍스트로 새 `Text` 인스턴스를 생성합니다.
    /// - Parameter placeholderLength: 생성할 플레이스홀더 단어 수
    public init(placeholderLength: Int) {
        precondition(placeholderLength > 0, "placeholderLength must be at least 1.")

        let baseWords = ["Lorem", "ipsum", "dolor", "sit", "amet,", "consectetur", "adipiscing", "elit."]

        var finalWords: [String]

        if placeholderLength < baseWords.count {
            finalWords = Array(baseWords.prefix(placeholderLength))
        } else {
            let otherWords = [
                "ad", "aliqua", "aliquip", "anim", "aute", "cillum", "commodo", "consequat", "culpa", "cupidatat",
                "deserunt", "do", "dolor", "dolore", "duis", "ea", "eiusmod", "enim", "esse", "est", "et",
                "eu", "ex", "excepteur", "exercitation", "fugiat", "id", "in", "incididunt", "irure",
                "labore", "laboris", "laborum", "magna", "minim", "mollit", "nisi", "non", "nostrud", "nulla",
                "occaecat", "officia", "pariatur", "proident", "qui", "quis", "reprehenderit", "sed", "sint", "sunt",
                "tempor", "ullamco", "ut", "velit", "veniam", "voluptate"
            ]

            var isStartOfSentence = false
            finalWords = baseWords

            for _ in baseWords.count ..< placeholderLength {
                let randomWord = otherWords.randomElement() ?? "ad"
                var formattedWord = isStartOfSentence ? randomWord.capitalized : randomWord
                isStartOfSentence = false

                // 무작위로 구두점 추가 — 10% 확률로 쉼표, 10% 확률로 마침표
                let punctuationProbability = Int.random(in: 1 ... 10)
                if punctuationProbability == 1 {
                    formattedWord.append(",")
                } else if punctuationProbability == 2 {
                    formattedWord.append(".")
                    isStartOfSentence = true
                }

                finalWords.append(formattedWord)
            }
        }

        var result = finalWords.joined(separator: " ").trimmingCharacters(in: .punctuationCharacters)
        result += "."

        self.content = result
    }

    /// 원시 HTML 또는 일반 텍스트 문자열로 새 Text를 생성합니다.
    /// [KalSae 포크] Markdown 파싱 없이 문자열을 그대로 사용합니다.
    /// - Parameter markdown: 표시할 텍스트 (그대로 사용됨)
    public init(markdown: String) {
        self.content = markdown
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        if isMultilineMarkdown {
            // HTMLCollection은 각 자식에 속성을 전달합니다.
            // color 같은 스타일은 문제없지만, padding 같은 스타일은
            // 단락 전체에 적용되어야 하므로 Section으로 감쌓니다.
            Section(content)
                .attributes(attributes)
                .markup()
        } else {
            Markup(
                "<\(font.rawValue)\(attributes)>" +
                content.markupString() +
                "</\(font.rawValue)>"
            )
        }
    }
}

extension HTML {
    /// 폰트 스타일을 적용합니다.
    /// 클래스 기반 스타일이면 CSS 클래스를 추가하고,
    /// Text 타입이면 font 프로퍼티를 직접 변경합니다.
    func fontStyle(_ font: Font.Style) -> any HTML {
        var copy: any HTML = self
        if Font.Style.classBasedStyles.contains(font), let sizeClass = font.sizeClass {
            copy.attributes.append(classes: sizeClass)
        } else if var text = copy as? Text {
            text.font = font
            copy = text
        } else if var anyHTML = copy as? AnyHTML, var text = anyHTML.wrapped as? Text {
            text.font = font
            anyHTML.wrapped = text
            copy = anyHTML
        }
        return copy
    }
}

extension InlineElement {
    func fontStyle(_ font: Font.Style) -> any InlineElement {
        var copy: any InlineElement = self
        copy.attributes.append(classes: font.sizeClass)
        return copy
    }
}
