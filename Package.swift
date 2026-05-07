// swift-tools-version: 6.0
// 이 패키지를 빌드하는 데 필요한 최소 Swift 버전을 선언합니다.
//
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경]
// - 퍼블리싱 계층 제거: IgniteCLI 타겟, 번들 리소스, 테스트 타겟 제거
// - 의존성 축소: swift-markdown, SwiftSoup, swift-argument-parser 제거
// - 플랫폼 추가: iOS 17+ 지원
// - 유일한 외부 의존성: swift-collections (OrderedSet/OrderedDictionary)
//

import PackageDescription

let package = Package(
    name: "Ignite",
    platforms: [.macOS(.v13), .iOS(.v17)],  // iOS 17+ 추가 (WebView 지원)
    products: [
        .library(name: "Ignite", targets: ["Ignite"]),  // HTML 생성 DSL 라이브러리
    ],
    dependencies: [
        // OrderedSet, OrderedDictionary 등 정렬된 컬렉션 (CoreAttributes에서 사용)
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
    ],
    targets: [
        .target(
            name: "Ignite",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
    ]
)
