//
// InlineStyleModifier.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] HeadElement extension 제거 (Head 요소 미사용)
//

/// 인라인 CSS 스타일을 블록 요소에 적용하는 내부 헬퍼
/// primitive가 아닌 요소는 Section으로 래핑하여 스타일을 적용합니다.
@MainActor private func inlineStyleModifier(
    _ styles: [InlineStyle],
    content: any BodyElement
) -> any BodyElement {
    var copy: any BodyElement = content.isPrimitive ? content : Section(content)
    copy.attributes.append(styles: styles)
    return copy
}

/// 인라인 CSS 스타일을 인라인 요소에 적용하는 내부 헬퍼
/// primitive가 아닌 요소는 Span으로 래핑하여 스타일을 적용합니다.
@MainActor private func inlineStyleModifier(
    _ styles: [InlineStyle],
    content: any InlineElement
) -> any InlineElement {
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.append(styles: styles)
    return copy
}

public extension HTML {
    /// HTML 요소에 인라인 CSS 스타일 속성을 추가합니다.
    /// - Parameters:
    ///   - property: 설정할 CSS 속성
    ///   - value: 해당 속성의 값
    /// - Returns: 스타일이 추가된 요소의 수정된 복사본
    func style(_ property: Property, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

public extension InlineElement {
    /// 인라인 요소에 인라인 CSS 스타일 속성을 추가합니다.
    /// - Parameters:
    ///   - property: 설정할 CSS 속성
    ///   - value: 해당 속성의 값
    /// - Returns: 스타일이 추가된 요소의 수정된 복사본
    func style(_ property: Property, _ value: String) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier([.init(property, value: value)], content: self))
    }
}

extension HTML {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> some HTML {
        AnyHTML(inlineStyleModifier([.init(property, value: value)], content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> some HTML {
        let styles = values.compactMap(\.self)
        return AnyHTML(inlineStyleModifier(styles, content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> some HTML {
        AnyHTML(inlineStyleModifier(styles, content: self))
    }
}

extension InlineElement {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `InlineElement` element
    func style(_ property: String, _ value: String) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier([.init(property, value: value)], content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ values: InlineStyle?...) -> some InlineElement {
        let styles = values.compactMap(\.self)
        return AnyInlineElement(inlineStyleModifier(styles, content: self))
    }

    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ styles: [InlineStyle]) -> some InlineElement {
        AnyInlineElement(inlineStyleModifier(styles, content: self))
    }
}

extension BodyElement {
    /// Adds inline styles to the element.
    /// - Parameter styles: An array of `InlineStyle` objects
    /// - Returns: The modified `InlineElement` element
    func style(_ styles: [InlineStyle]) -> some BodyElement {
        AnyHTML(inlineStyleModifier(styles, content: self))
    }
}
