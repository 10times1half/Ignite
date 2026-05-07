//
// Script.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] HeadElement 제거 (HTML만 conform), file.absoluteString 직접 사용
//

import Foundation

/// 페이지에 JavaScript를 삽입합니다. 외부 파일 참조 또는 인라인 코드 도 가능.
public struct Script: HTML {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 로드할 외부 파일 URL
    private var file: URL?

    /// 직접 실행할 인라인 JavaScript 코드
    private var code: String?

    /// 로컬 파일 경로로 새 스크립트를 생성합니다.
    /// - Parameter file: 로드할 파일의 경로 문자열
    public init(file: String) {
        self.file = URL(string: file)
    }

    /// 외부 URL로 새 스크립트를 생성합니다.
    /// - Parameter file: 로드할 파일의 URL
    public init(file: URL) {
        self.file = file
    }

    /// 사용자 정의 인라인 JavaScript를 페이지에 삽입합니다.
    public init(code: String) {
        self.code = code
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] file.absoluteString을 직접 src에 사용합니다.
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        var attributes = attributes
        if let file {
            let path = file.absoluteString
            attributes.append(customAttributes: .init(name: "src", value: path))
            return Markup("<script\(attributes)></script>")
        } else if let code {
            return Markup("<script\(attributes)>\(code)</script>")
        } else {
            return Markup()
        }
    }
}

public extension Script {
    /// 요소에 type 속성을 추가합니다.
    /// - Parameter value: type 속성의 값
    /// - Returns: 수정된 `Script` 요소
    func type(value: String) -> Self {
        var copy = self
        copy.attributes.append(customAttributes: .init(name: "type", value: value))
        return copy
    }
}
