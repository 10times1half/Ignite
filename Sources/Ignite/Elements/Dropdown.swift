//
// Dropdown.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] hasActiveItem 제거 (active 상태 자동 추적 없음)
//

/// `DropdownItem`을 구현한 요소는 Dropdown 내부에 표시할 수 있습니다.
public protocol DropdownItem: BodyElement {}

/// 누르면 메뉴를 표시하는 버튼을 렌더링합니다.
/// 독립적으로 사용하거나 `NavigationBar` 내부에서 사용할 수 있습니다.
public struct Dropdown: HTML, NavigationItem, FormItem {
    /// 컨텍스트에 따른 드롭다운 렌더링 방식
    enum Configuration: Sendable {
        /// 독립 드롭다운으로 렌더링
        case standalone
        /// 내비게이션 바 내부에 배치
        case navigationBarItem
        /// 컨트롤 그룹 내부에 배치
        case controlGroupItem
        /// 컨트롤 그룹의 마지막 항목으로 배치
        case lastControlGroupItem
    }

    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// `NavigationBar`에서 이 항목의 브레이크포인트별 표시 방식
    public var navigationBarVisibility: NavigationBarVisibility = .automatic

    /// 드롭다운의 제목
    private var title: any InlineElement

    /// 드롭다운 메뉴에 표시할 항목 배열
    private var items: [any DropdownItem]

    /// 드롭다운 크기. 기본값: `.medium`
    private var size = Button.Size.medium

    /// 드롭다운의 스타일. 기본값: `.default`
    private var role = Role.default

    /// 드롭다운을 독립 요소로 생성할지, 부모의 구조를 사용할지 결정
    private var configuration: Configuration = .standalone

    /// 제목과 항목 빌더로 새 `Dropdown` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - title: 드롭다운 버튼의 제목
    ///   - items: 메뉴에 표시할 항목들
    public init(
        _ title: any InlineElement,
        @ElementBuilder<any DropdownItem> items: () -> [any DropdownItem]
    ) {
        self.title = title
        self.items = items()
    }

    /// 항목 빌더와 제목 빌더로 새 `Dropdown` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - items: 메뉴에 표시할 항목들
    ///   - title: 드롭다운 버튼의 제목
    public init(
        @ElementBuilder<any DropdownItem> items: () -> [any DropdownItem],
        @InlineElementBuilder title: () -> any InlineElement
    ) {
        self.items = items()
        self.title = title()
    }

    /// 드롭다운의 크기를 조정합니다.
    /// - Parameter size: 새 크기
    /// - Returns: 크기가 업데이트된 새 `Dropdown` 인스턴스
    public func dropdownSize(_ size: Button.Size) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// 드롭다운의 역할을 조정합니다.
    /// - Parameter role: 새 역할
    /// - Returns: 역할이 업데이트된 새 `Dropdown` 인스턴스
    public func role(_ role: Role) -> Dropdown {
        var copy = self
        copy.role = role
        return copy
    }

    /// 드롭다운의 렌더링 컨텍스트를 설정합니다.
    /// - Parameter configuration: The context in which this dropdown will be used.
    /// - Returns: A configured dropdown instance.
    func configuration(_ configuration: Configuration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        if configuration == .standalone {
            Section(renderDropdownContent())
                .attributes(attributes)
                .class("dropdown")
                .markup()
        } else {
            renderDropdownContent()
                .attributes(attributes)
                .markup()
        }
    }

    /// Creates the internal dropdown structure including the trigger button and menu items.
    /// 드롭다운 트리거와 메뉴 리스트를 렌더링합니다.
    /// [KalSae 포크] active 상태 자동 추적 없음.
    /// - Returns: 트리거와 메뉴 리스트를 담은 그룹
    @HTMLBuilder
    private func renderDropdownContent() -> some BodyElement {
        if configuration == .navigationBarItem {
            let titleAttributes = title.attributes
            let title = title.clearingAttributes()

            Link(title, target: "#")
                .customAttribute(name: "role", value: "button")
                .class("dropdown-toggle", "nav-link")
                .data("bs-toggle", "dropdown")
                .aria(.expanded, "false")
                .attributes(titleAttributes)
        } else {
            Button(title)
                .class(Button.classes(forRole: role, size: size))
                .class("dropdown-toggle")
                .data("bs-toggle", "dropdown")
                .aria(.expanded, "false")
        }

        List {
            ForEach(items) { item in
                if let link = item as? Link {
                    ListItem {
                        link.class("dropdown-item")
                    }
                } else if let text = item as? Text {
                    ListItem {
                        text.class("dropdown-header")
                    }
                }
            }
        }
        .listMarkerStyle(.unordered(.automatic))
        .class("dropdown-menu")
        .class(configuration == .lastControlGroupItem ? "dropdown-menu-end" : nil)
    }
}

private extension InlineElement {
    /// 모든 속성이 제거된 요소의 복사본을 반환합니다.
    func clearingAttributes() -> some InlineElement {
        var copy = self
        copy.attributes = CoreAttributes()
        return copy
    }
}
