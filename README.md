# Ignite (KalSae HTML-Only Fork)

> Swift DSL → HTML 변환 라이브러리  
> [Ignite](https://github.com/twostraws/Ignite)(MIT)에서 퍼블리싱 계층을 제거하고,  
> [KalSae](https://github.com/10times1half/KalSae) WebView 프론트엔드용으로 경량화한 포크입니다.

## 설치

### KalSae CLI로 프로젝트 생성 (권장)

```bash
kalsae new MyApp --frontend ignite
```

Ignite를 프론트엔드로 선택하면 생성된 프로젝트의 Package.swift에 자동으로 의존성이 추가됩니다.

### 기존 프로젝트에 수동 추가

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/10times1half/Ignite.git", branch: "kalsae-html-only"),
]

// 타겟: .target(name: "YourApp", dependencies: ["KalSae", "Ignite"])
```

> KalSae 프레임워크 자체는 Ignite에 의존하지 않습니다.  
> Ignite는 앱 프로젝트의 선택적 의존성으로, 필요할 때만 추가하면 됩니다.  
> 유일한 외부 의존성: `swift-collections` (OrderedSet)

## 사용법

```swift
import KalSae
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
await app.loadHTML(html)
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

## 수정 파일 상세

이 포크에서 원본 대비 수정된 파일 목록입니다.  
모든 수정 파일에는 `[KalSae 포크]` 또는 `[KalSae 포크 변경]` 태그가 달려 있어 upstream 머지 시 충돌 지점을 쉽게 식별할 수 있습니다.

### Package.swift

| 파일 | 변경 내용 |
|------|----------|
| `Package.swift` | 전면 재작성. IgniteCLI/테스트 타겟 제거, swift-markdown·SwiftSoup·ArgumentParser 의존성 제거, iOS 17+ 추가 |

### Elements (10개)

| 파일 | 역할 | 변경 내용 |
|------|------|----------|
| `Text.swift` | 단락/제목 텍스트 | `init(markdown:)` Markdown 파싱 제거, `init(markup:parser:)` 삭제 |
| `Link.swift` | 하이퍼링크 | StaticPage/Article init 제거, URL을 그대로 href에 사용 |
| `LinkGroup.swift` | 블록 하이퍼링크 | Link.swift와 동일 패턴 적용 |
| `Image.swift` | 이미지 | 데드코드 제거 (findVariants, generateSourceSet 등), 경로 직접 src에 사용 |
| `Script.swift` | JavaScript 삽입 | HeadElement → HTML 변경, file.absoluteString 직접 사용 |
| `Audio.swift` | 오디오 재생 | publishingContext.addWarning() 제거 |
| `Video.swift` | 비디오 재생 | publishingContext.addWarning() 제거 |
| `Embed.swift` | 외부 콘텐츠 임베드 | 변경 적음 (독립적 동작) |
| `NavigationBar.swift` | 상단 내비게이션 바 | active 상태 자동 추적 제거 |
| `Dropdown.swift` | 드롭다운 메뉴 | hasActiveItem 제거 (항상 false였던 변수) |

### Modifiers & Framework (5개)

| 파일 | 역할 | 변경 내용 |
|------|------|----------|
| `Hint.swift` | 툴팁 모디파이어 | Markdown 힌트를 일반 텍스트로 폴백 처리 |
| `InlineStyleModifier.swift` | 인라인 CSS 스타일 | HeadElement extension 제거 |
| `ElementBuilder.swift` | Result Builder | HeadElementBuilder 등 퍼블리싱 관련 typealias 제거 |
| `Defaultable.swift` | 기본값 프로토콜 | HighlighterTheme extension 제거 |
| `MarkupElement.swift` | 핵심 HTML 프로토콜 | publishingContext 연산 프로퍼티 제거 |

### Themes (2개)

| 파일 | 역할 | 변경 내용 |
|------|------|----------|
| `Theme.swift` | 테마 프로토콜 정의 | syntaxHighlighterTheme 프로퍼티 제거 |
| `Theme-DefaultImplementation.swift` | Bootstrap 기본 테마값 | syntaxHighlighterTheme 기본값 제거 |

## 패키지 버전 관리

### 브랜치 추적 (기본)

```swift
.package(url: "https://github.com/10times1half/Ignite.git", branch: "kalsae-html-only")
```

`kalsae-html-only` 브랜치에 머지 후 push하면 `swift package update` 시 자동 반영됩니다.

### 커밋 고정 (안정성 우선)

```swift
.package(url: "https://github.com/10times1half/Ignite.git", revision: "6237215f")
```

특정 커밋에 고정하면 의도하지 않은 변경을 방지할 수 있습니다.  
업데이트가 필요할 때 revision 값을 수동으로 변경하세요.

> **권장:** Ignite 원본이 활발히 변하는 시기에는 **커밋 고정**, 안정기에는 **브랜치 추적**이 적합합니다.

## 업스트림 동기화

### 기본 동기화

```bash
# upstream 등록 (최초 1회)
git remote add upstream https://github.com/twostraws/Ignite.git

# 동기화
git fetch upstream
git log upstream/main --oneline -10  # 변경 내용 확인
git merge upstream/main              # kalsae-html-only 브랜치에서
# 충돌 해결 후 push
git push origin kalsae-html-only
```

### 동기화 시점

매번 동기화할 필요 없습니다. 다음 경우에만 동기화하세요.

| 상황 | 액션 |
|------|------|
| 필요한 새 요소/모디파이어가 추가됨 | merge |
| 버그 수정이 올라옴 | merge |
| KalSae가 잘 동작 중 | 그대로 유지 |

### 충돌 범위

- **삭제한 파일이 upstream에서 수정되면** → 충돌 없이 무시됩니다 (이미 삭제했으므로)
- **새 요소/모디파이어가 추가되면** → `PublishingContext`를 참조하지 않는 한 자동 머지됨
- **수정한 ~15개 파일** → 여기서만 충돌 발생 가능 (Text, Link, Image, Script 등)
- **upstream이 `PublishingContext` API를 변경하면** → 수정한 파일들에서 충돌 발생

## 라이선스

이 포크는 원본 [Ignite](https://github.com/twostraws/Ignite)의 MIT 라이선스를 그대로 따릅니다.

- 원본 라이선스: [LICENSE](LICENSE) 참조
- 포크에서의 변경: 퍼블리싱 계층 제거 및 KalSae 프론트엔드용 경량화
- 저작권 표기: 원본 저자(Paul Hudson / @twostraws) 표기를 유지합니다
- MIT 라이선스이므로 상업적 사용, 수정, 배포, 서브라이선스 모두 가능합니다
