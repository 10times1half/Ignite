//
// LinkGroup.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] StaticPage/Article init 제거, URL을 그대로 href에 사용
//

import Foundation

/// 블록 콘텐츠를 감싸는 하이퍼링크 (HTML 요소를 하위 콘텐츠로 포함 가능)
public struct LinkGroup: HTML {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 링크 내부에 표시할 콘텐츠
    var content: any BodyElement

    /// 링크가 가리키는 URL
    var url: String

    /// 제공된 콘텐츠로 `LinkGroup` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - target: 링크할 URL
    ///   - content: 링크 내부에 표시할 HTML 콘텐츠
    public init(target: String, @HTMLBuilder content: @escaping () -> some HTML) {
        self.content = content()
        self.url = target
    }

    /// 이 페이지를 열 창을 제어합니다.
    /// - Parameter target: 적용할 새 타겟
    /// - Returns: 타겟이 업데이트된 새 `LinkGroup` 인스턴스
    public func target(_ target: LinkTarget) -> Self {
        if let name = target.name {
            var copy = self
            let attribute = Attribute(name: "target", value: name)
            copy.attributes.append(customAttributes: attribute)
            return copy
        } else {
            return self
        }
    }

    /// 링크에 메타데이터 관계(rel 속성)를 설정합니다.
    /// - Parameter relationship: 추가할 관계들
    /// - Returns: 관계가 업데이트된 새 `LinkGroup` 인스턴스
    public func relationship(_ relationship: LinkRelationship...) -> Self {
        var copy = self
        let attributeValue = relationship.map(\.rawValue).joined(separator: " ")
        let attribute = Attribute(name: "rel", value: attributeValue)
        copy.attributes.append(customAttributes: attribute)
        return copy
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] URL을 그대로 href에 사용합니다 (경로 변환 없음).
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        isPrivacySensitive
            ? renderPrivacyProtectedLink()
            : renderStandardLink()
    }

    /// 이 링크에 개인정보 보호가 필요한 콘텐츠가 있는지 여부
    private var isPrivacySensitive: Bool {
        attributes.customAttributes.contains { $0.name == "privacy-sensitive" }
    }

    /// 개인정보 보호가 활성화된 링크를 렌더링합니다.
    /// URL과 선택적으로 표시 콘텐츠를 Base64 인코딩합니다.
    /// - Returns: 인코딩된 속성과 콘텐츠를 가진 HTML 앵커 태그
    private func renderPrivacyProtectedLink() -> Markup {
        let displayText = content.markupString()
        let encodingType = attributes.customAttributes.first { $0.name == "privacy-sensitive" }?.value ?? "urlOnly"

        let encodedUrl = Data(url.utf8).base64EncodedString()
        let displayContent = switch encodingType {
        case "urlAndDisplay": Data(displayText.utf8).base64EncodedString()
        default: displayText
        }

        var linkAttributes = attributes.appending(classes: "link-plain", "d-inline-block")
        linkAttributes.append(classes: "protected-link")
        linkAttributes.append(dataAttributes: .init(name: "encoded-url", value: encodedUrl))
        linkAttributes.append(customAttributes: .init(name: "href", value: "#"))

        return Markup("a\(linkAttributes)>\(displayContent)</a>")
    }

    /// 표준 링크를 렌더링합니다.
    /// [KalSae 포크] URL을 그대로 href에 사용합니다.
    /// - Returns: href와 콘텐츠가 포함된 HTML 앵커 태그
    private func renderStandardLink() -> Markup {
        var linkAttributes = attributes.appending(classes: "link-plain", "d-inline-block")
        linkAttributes.append(customAttributes: .init(name: "href", value: url))
        return Markup("<a\(linkAttributes)>\(content.markupString())</a>")
    }
}
