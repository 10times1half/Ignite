//
// Image.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] 데드코드 제거 (findVariants, generateSourceSet 등),
//   markup()에서 경로를 직접 src에 사용 (업소스 기반 변환 없음)
//

import Foundation

/// 페이지의 이미지 요소. 벡터(SVG) 또는 래스터(JPG, PNG, GIF) 지원.
public struct Image: InlineElement, LazyLoadable {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some InlineElement { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 이미지 경로 (URL 또는 상대 경로)
    var path: URL?

    /// Bootstrap 내장 아이콘 이름 (https://icons.getbootstrap.com 참조)
    var systemImage: String?

    /// 스크린 리더용 접근성 레이블
    var description: String?

    /// 지정된 경로로 새 `Image` 인스턴스를 생성합니다.
    /// [KalSae 포크] `@2x`/`~dark` 변형 자동 감지 불가. 전체 경로로 직접 지정하세요.
    /// - Parameters:
    ///   - path: 이미지 파일 경로 (예: /images/welcome.jpg)
    ///   - description: 스크린 리더용 이미지 설명
    public init(_ path: String, description: String? = nil) {
        self.path = URL(string: path)
        self.description = description
    }

    /// Bootstrap 내장 아이콘으로 새 `Image` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - systemName: https://icons.getbootstrap.com 에서 선택한 아이콘 이름
    ///   - description: 스크린 리더용 이미지 설명
    public init(systemName: String, description: String? = nil) {
        self.systemImage = systemName
        self.description = description
    }

    /// 장식용 이미지를 생성합니다. 스크린 리더에서 숨겨집니다.
    /// - Parameter name: 이미지 파일 경로 (예: /images/dog.jpg)
    public init(decorative name: String) {
        self.path = URL(string: name)
        self.description = ""
    }

    /// 컨테이너에 맞춰 이미지 크기를 유동적으로 조절할 수 있게 합니다.
    /// - Returns: 유동 크기가 설정된 새 `Image` 인스턴스
    public func resizable() -> Self {
        var copy = self
        copy.attributes.append(classes: "img-fluid")
        return copy
    }

    /// 스크린 리더용 접근성 레이블을 설정합니다.
    /// - Parameter label: 새 접근성 레이블
    /// - Returns: 레이블이 업데이트된 새 `Image` 인스턴스
    public func accessibilityLabel(_ label: String) -> Self {
        var copy = self
        copy.description = label
        return copy
    }

    /// Bootstrap 시스템 아이콘을 렌더링합니다.
    /// - Parameters:
    ///   - icon: 렌더링할 시스템 아이콘 이름
    ///   - description: 접근성 레이블
    /// - Returns: 이 요소의 HTML
    private func render(icon: String, description: String) -> Markup {
        var attributes = attributes
        attributes.append(classes: "bi-\(icon)")
        return Markup("<i\(attributes)></i>")
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] 경로를 직접 src에 사용, 변형(@2x/~dark) 감지 없음.
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        if let systemImage {
            return render(icon: systemImage, description: description ?? "")
        } else if let path {
            var attributes = attributes
            attributes.append(customAttributes:
                .init(name: "src", value: path.relativeString),
                .init(name: "alt", value: description ?? ""))
            return Markup("<img\(attributes) />")
        } else {
            return Markup()
        }
    }
}
