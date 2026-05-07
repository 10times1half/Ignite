//
// Link.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] StaticPage/Article init 제거, URL을 그대로 href에 사용
//   (원본은 publishingContext.linkPath(for:)로 변환)
//

import Foundation

/// 이 사이트 또는 외부 리소스로의 하이퍼링크
public struct Link: InlineElement, NavigationItem, DropdownItem {
    /// 링크에 적용할 시각적 스타일
    public enum Style: Equatable {
        /// 밑줄 효과가 있는 링크
        /// - Parameters:
        ///   - base: 기본 상태의 밑줄 강도
        ///   - hover: 호버 시 밑줄 강도
        case underline(_ base: UnderlineProminence, hover: UnderlineProminence)

        /// 버튼처럼 보이고 동작하는 링크
        case button

        /// 기본/호버 상태 모두 동일한 밑줄 강도로 링크 스타일을 생성합니다.
        /// - Parameter prominence: 양쪽 상태에 사용할 밑줄 강도
        /// - Returns: 동일한 기본/호버 강도를 가진 `LinkStyle`
        public static func underline(_ prominence: UnderlineProminence) -> Self {
            .underline(prominence, hover: prominence)
        }

        /// 기본 링크 스타일 (heavy 밑줄)
        public static var automatic: Style { .underline(.heavy, hover: .heavy) }
    }

    /// 이 HTML의 콘텐츠와 동작
    public var body: some InlineElement { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// `NavigationBar`에서 이 항목의 브레이크포인트별 표시 방식
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// 링크 내부에 표시할 콘텐츠
    var content: any InlineElement

    /// 링크가 가리키는 URL
    var url: String

    /// 링크 스타일. 기본값: `.automatic`
    var style = Style.automatic

    /// `.button` 스타일로 렌더링할 때의 버튼 크기
    var size = Button.Size.medium

    /// 링크의 역할 (다양한 스타일 효과 적용)
    var role = Role.default

    /// 이 링크를 스타일링하는 데 필요한 CSS 클래스 배열을 반환합니다.
    var linkClasses: [String] {
        var outputClasses = [String]()

        switch style {
        case .button:
            outputClasses.append(contentsOf: Button.classes(forRole: role, size: size))
        case .underline(let baseDecoration, hover: let hoverDecoration) where style != .automatic:
            outputClasses.append("link-underline")
            outputClasses.append("link-underline-opacity-\(baseDecoration)")
            outputClasses.append("link-underline-opacity-\(hoverDecoration)-hover")
            fallthrough
        default:
            if role == .none {
                outputClasses.append("link-plain")
            } else if role != .default {
                outputClasses.append("link-\(role.rawValue)")
            }
        }

        return outputClasses
    }

    /// 제공된 콘텐츠로 `Link` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - content: 링크 내부에 표시할 콘텐츠
    ///   - target: 링크할 URL
    public init(_ content: any InlineElement, target: String) {
        self.content = content
        self.url = target
    }

    /// 빌더를 사용하여 `Link` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - content: 링크 내부에 표시할 콘텐츠
    ///   - target: 링크할 URL
    public init(target: String, @InlineElementBuilder content: () -> some InlineElement) {
        self.content = content()
        self.url = target
    }

    /// URL 타입으로 `Link` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - content: 링크 내부에 표시할 문자열
    ///   - target: 링크할 URL
    public init(_ content: String, target: URL) {
        self.content = content
        self.url = target.absoluteString
    }

    /// 이 페이지를 열 창을 제어합니다.
    /// - Parameter target: 적용할 새 타겟
    /// - Returns: 타겟이 업데이트된 새 `Link` 인스턴스
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

    /// `.button` 스타일 렌더링 시 버튼 크기를 조정합니다.
    /// - Parameter size: 새 크기
    /// - Returns: 크기가 업데이트된 새 `Link` 인스턴스
    public func buttonSize(_ size: Button.Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// 링크의 역할을 조정합니다.
    /// - Parameter role: 새 역할
    /// - Returns: 역할이 업데이트된 새 `Link` 인스턴스
    public func role(_ role: Role) -> Self {
        var copy = self
        copy.role = role
        return copy
    }

    /// 링크의 스타일을 조정합니다.
    /// - Parameter style: 새 스타일
    /// - Returns: 스타일이 업데이트된 새 `Link` 인스턴스
    public func linkStyle(_ style: Style) -> Self {
        var copy = self
        copy.style = style

        // 이 링크에 역할이 없으면 기본 버튼 스타일을 위해 자동으로 추가
        if copy.role == .default {
            copy.role = .primary
        }

        return copy
    }

    /// 링크에 메타데이터 관계(rel 속성)를 설정합니다.
    /// - Parameter relationship: 추가할 관계들
    /// - Returns: 관계가 업데이트된 새 `Link` 인스턴스
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

        var linkAttributes = attributes.appending(classes: linkClasses)
        linkAttributes.append(classes: "protected-link")
        linkAttributes.append(dataAttributes: .init(name: "encoded-url", value: encodedUrl))
        linkAttributes.append(customAttributes: .init(name: "href", value: "#"))

        return Markup("a\(linkAttributes)>\(displayContent)</a>")
    }

    /// 표준 링크를 렌더링합니다.
    /// [KalSae 포크] URL을 그대로 href에 사용합니다.
    /// - Returns: href와 콘텐츠가 포함된 HTML 앵커 태그
    private func renderStandardLink() -> Markup {
        var linkAttributes = attributes.appending(classes: linkClasses)
        linkAttributes.append(customAttributes: .init(name: "href", value: url))
        return Markup("<a\(linkAttributes)>\(content.markupString())</a>")
    }
}
