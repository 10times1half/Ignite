//
// Hint.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] Markdown 힌트를 일반 텍스트로 폴백 처리 (MarkdownToHTML 제거됨)
//

/// 일반 텍스트 툴팁용 Bootstrap data 속성을 생성합니다.
private func hintData(text: String) -> [Attribute] {
    [.init(name: "bs-toggle", value: "tooltip"),
     .init(name: "bs-title", value: text)]
}

/// HTML 콘텐츠 툴팁용 Bootstrap data 속성을 생성합니다.
private func hintData(html: String) -> [Attribute] {
    [.init(name: "bs-toggle", value: "tooltip"),
     .init(name: "bs-title", value: html),
     .init(name: "bs-html", value: "true")]
}

/// Markdown 툴팁용 data 속성을 생성합니다.
/// [KalSae 포크] Markdown 파싱 없이 일반 텍스트로 처리합니다.
private func hintData(markdown: String) -> [Attribute] {
    return hintData(text: markdown)
}

/// 툴팁 data 속성을 HTML 요소에 적용하는 내부 헬퍼
@MainActor private func hintModifier(
    data: [Attribute],
    content: any HTML
) -> any HTML {
    data.reduce(content) { $0.data($1.name, $1.value!) }
}

/// 툴팁 data 속성을 인라인 요소에 적용하는 내부 헬퍼
@MainActor private func hintModifier(
    data: [Attribute],
    content: any InlineElement
) -> any InlineElement {
    data.reduce(content) { $0.data($1.name, $1.value!) }
}

public extension HTML {
    /// 일반 텍스트 툴팁을 이 요소에 추가합니다.
    /// - Parameter text: 툴팁에 표시할 텍스트
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(text: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(text: text), content: self))
    }

    /// HTML 콘텐츠 툴팁을 이 요소에 추가합니다.
    /// - Parameter html: 툴팁에 표시할 HTML
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(html: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(html: html), content: self))
    }

    /// Markdown 텍스트 툴팁을 이 요소에 추가합니다.
    /// [KalSae 포크] 이 포크에서는 Markdown 파싱 없이 일반 텍스트로 처리됩니다.
    /// - Parameter markdown: Markdown 텍스트
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(markdown: String) -> some HTML {
        AnyHTML(hintModifier(data: hintData(markdown: markdown), content: self))
    }
}

public extension InlineElement {
    /// 일반 텍스트 툴팁을 이 인라인 요소에 추가합니다.
    /// - Parameter text: 툴팁에 표시할 텍스트
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(text: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(text: text), content: self))
    }

    /// HTML 콘텐츠 툴팁을 이 인라인 요소에 추가합니다.
    /// - Parameter html: 툴팁에 표시할 HTML
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(html: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(html: html), content: self))
    }

    /// Markdown 텍스트 툴팁을 이 인라인 요소에 추가합니다.
    /// [KalSae 포크] 이 포크에서는 Markdown 파싱 없이 일반 텍스트로 처리됩니다.
    /// - Parameter markdown: Markdown 텍스트
    /// - Returns: 툴팁이 연결된 요소의 수정된 복사본
    func hint(markdown: String) -> some InlineElement {
        AnyInlineElement(hintModifier(data: hintData(markdown: markdown), content: self))
    }
}
