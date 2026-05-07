//
// ElementBuilder.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] HeadElementBuilder, StaticPageBuilder, ErrorPageBuilder,
//   ArticlePageBuilder typealias 제거 (퍼블리싱 관련 빌더 미사용)
//

typealias ActionBuilder = ElementBuilder<any Action>

/// 제네릭 콘텐츠 배열을 선언적으로 구성할 수 있는 Result Builder
@resultBuilder
public struct ElementBuilder<T> {
    /// 가변 인자로 전달된 여러 배열을 1차원 배열로 평탄화합니다.
    /// - Parameter components: 요소 배열의 가변 인자
    /// - Returns: 평탄화된 1차원 요소 배열
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap(\.self)
    }

    /// 2차원 배열을 1차원 배열로 평탄화합니다. (반복문 지원)
    /// - Parameter components: 타입 T의 2차원 배열
    /// - Returns: 평탄화된 1차원 배열
    public static func buildArray(_ components: [[T]]) -> [T] {
        components.flatMap(\.self)
    }

    /// 단일 객체를 같은 타입의 배열로 변환합니다.
    /// - Parameter expression: 타입 T의 단일 값
    /// - Returns: 해당 값을 담은 배열
    public static func buildExpression(_ expression: T) -> [T] {
        [expression]
    }

    /// 옵셔널 배열을 처리합니다. 값이 있으면 반환하고, 없으면 빈 배열을 반환합니다.
    /// - Parameter component: 타입 T의 옵셔널 배열
    /// - Returns: 요소 배열 (비어 있을 수 있음)
    public static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }

    /// 조건문의 첫 번째 분기를 처리합니다. `buildEither(second:)`와 함께 if/else를 지원합니다.
    /// - Returns: 입력 배열을 그대로 반환
    public static func buildEither(first component: [T]) -> [T] {
        component
    }

    /// 조건문의 두 번째 분기를 처리합니다. `buildEither(first:)`와 함께 if/else를 지원합니다.
    /// - Parameter component: 타입 T의 배열
    /// - Returns: 입력 배열을 그대로 반환
    public static func buildEither(second component: [T]) -> [T] {
        component
    }
}
