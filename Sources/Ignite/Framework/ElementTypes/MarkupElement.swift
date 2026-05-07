//
// MarkupElement.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] publishingContext 연산 프로퍼티 제거
//

/// 모든 HTML 타입의 공통 동작을 정의하는 프로토콜
/// - Warning: 이 타입을 직접 conform하지 마세요. `HTML` 또는 `InlineElement`을 사용하세요.
@MainActor
public protocol MarkupElement: Sendable {
    /// HTML 요소의 표준 제어 속성 집합 (class, id, style, data 등)
    var attributes: CoreAttributes { get set }

    /// 이 요소와 자식 요소를 HTML 마크업으로 변환합니다.
    /// - Returns: HTML 마크업 문자열을 담은 `Markup` 인스턴스
    func markup() -> Markup
}

extension MarkupElement {
    /// 이 요소를 속성이 포함된 HTML 문자열로 변환합니다.
    /// - Returns: HTML 마크업 문자열
    func markupString() -> String {
        markup().string
    }

    func `is`(_ elementType: any MarkupElement.Type) -> Bool {
        switch self {
        case let element as any HTML:
            element.isType(elementType)
        case let element as any InlineElement:
            element.isType(elementType)
        default: false
        }
    }

    func `as`<T: MarkupElement>(_ elementType: T.Type) -> T? {
        switch self {
        case let element as any HTML:
            element.asType(elementType)
        case let element as any InlineElement:
            element.asType(elementType)
        default: nil
        }
    }
}

private extension HTML {
    /// Whether this element represents a specific type.
    func isType(_ elementType: any MarkupElement.Type) -> Bool {
        if let anyHTML = body as? AnyHTML {
            type(of: anyHTML.wrapped) == elementType
        } else {
            type(of: body) == elementType
        }
    }

    /// The underlying content, conditionally cast to the specified type.
    func asType<T: MarkupElement>(_ elementType: T.Type) -> T? {
        if let anyHTML = body as? AnyHTML, let element = anyHTML.attributedContent as? T {
            element
        } else if let element = body as? T {
            element
        } else {
            nil
        }
    }
}

private extension InlineElement {
    /// The underlying content, conditionally cast to the specified type.
    func asType<T: MarkupElement>(_ elementType: T.Type) -> T? {
        if let anyHTML = body as? AnyInlineElement, let element = anyHTML.attributedContent as? T {
            element
        } else if let element = body as? T {
            element
        } else {
            nil
        }
    }

    /// Whether this element represents a specific type.
    func isType(_ elementType: any MarkupElement.Type) -> Bool {
        if let anyHTML = body as? AnyInlineElement {
            type(of: anyHTML.wrapped) == elementType
        } else {
            type(of: body) == elementType
        }
    }
}
