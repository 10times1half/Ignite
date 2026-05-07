# Ignite (KalSae HTML-Only Fork)

> Swift DSL → HTML 변환 라이브러리  
> [Ignite](https://github.com/twostraws/Ignite)(MIT)에서 퍼블리싱 계층을 제거하고,  
> [KalSae](https://github.com/10times1half/KalSae) WebView 프론트엔드용으로 경량화한 포크입니다.

## 설치

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/10times1half/Ignite.git", branch: "kalsae-html-only"),
]

// 타겟: .target(name: "YourApp", dependencies: ["Ignite"])
```

유일한 외부 의존성: `swift-collections` (OrderedSet)

## 사용법

```swift
import Ignite

// Swift DSL로 HTML 문자열 생성
let html = Section {
    Text("Hello KalSae!")
        .font(.title1)
        .foregroundStyle(.red)
        .padding(.medium)

    Button("Click me")
        .role(.primary)
        .onClick { ShowAlert(message: "눌렸습니다!") }

    Card {
        Text("카드 내용")
    } header: {
        "카드 제목"
    }
    .cornerRadius(8)
    .shadow(radius: 4)
}.markupString()

// KalSae WebView에 로드
// await app.loadHTML(html)
```

## 포함된 기능

| 기능 | 설명 |
|------|------|
| **50+ HTML 요소** | Text, Button, Card, Modal, Table, List, Grid, Form, Accordion, Alert, Badge 등 |
| **40+ 모디파이어** | padding, margin, font, foregroundStyle, background, shadow, border, opacity, cornerRadius 등 |
| **애니메이션** | CSS 키프레임, 트랜지션, hover 이펙트 |
| **액션** | onClick, onHover 등 ShowAlert, ShowModal, HideElement, ToggleElementVisibility 등 |
| **테마** | Light/Dark 테마 정의, Bootstrap 변수 커스터마이징 |
| **커스텀 스타일** | 재사용 가능한 `Style` 프로토콜 (환경 조건별 대응) |
| **Result Builder** | `@HTMLBuilder`, `@InlineElementBuilder` 등 SwiftUI 방식의 선언적 구문 |

## 제거된 기능 (vs 원본 Ignite)

- 정적 사이트 퍼블리싱 (`PublishingContext`, sitemap, RSS, robots.txt)
- `Site`, `StaticPage`, `Layout`, `Article` 프레임워크
- `Head`, `Body`, `MetaTag`, `CodeBlock` 요소 (KalSae WebView가 문서 구조 관리)
- Markdown → HTML 파서 (`swift-markdown` 의존성 제거)
- `SwiftSoup` 의존성 제거
- CLI 도구 (`IgniteCLI`)
- 번들 리소스 (CSS/JS/폰트)

## 사용 가능한 요소 목록

**레이아웃:** Section, Group, Grid, Row, Column, HStack, VStack, ZStack, Spacer, Divider  
**텍스트:** Text, Span, Strong, Emphasis, Strikethrough, Underline, Code, Abbreviation  
**인터랙티브:** Button, ButtonGroup, Link, LinkGroup, Dropdown, Form, Input, TextField  
**컴포넌트:** Card, Accordion, Alert, Badge, Modal, Carousel, Table, List, NavigationBar  
**미디어:** Image (경로 직접 지정), Audio, Video, Embed  
**제어:** ForEach, InlineForEach, Tag, Label, ControlGroup

## 주의사항

- `Text(markdown:)` → Markdown 파싱 없이 문자열을 그대로 사용합니다.  
  Markdown 변환이 필요하면 별도 라이브러리를 사용하세요.
- `Image` → `@2x`/`~dark` 변형 자동 감지 불가. 전체 경로로 직접 지정하세요.
- `Link` → URL 문자열을 그대로 href에 사용합니다 (사이트 내부 경로 변환 없음).
- `NavigationBar`/`Dropdown` → active 상태 자동 추적 없음.  
  필요하면 `.class("active")`로 직접 추가하세요.
- **Bootstrap CSS 미포함** → KalSae 프론트엔드 HTML에 직접 포함하거나 CDN을 사용하세요.

## 업스트림 동기화

```bash
git remote add upstream https://github.com/twostraws/Ignite.git
git fetch upstream
git merge upstream/main
# 수정된 ~15개 파일에서만 충돌 발생 → 해결 후 push
git push origin kalsae-html-only
```

## 라이선스

Ignite는 MIT 라이선스입니다. [LICENSE](LICENSE) 참조.
