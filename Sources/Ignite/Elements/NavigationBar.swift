//
// NavigationBar.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] active 상태 자동 추적 제거 (publishingContext 의존)
//

/// 페이지 상단에 위치하는 내비게이션 바
public struct NavigationBar: HTML {
    /// 내비게이션 바의 색상 스키마
    public enum NavigationBarStyle {
        /// 자동 설정 사용
        case automatic
        /// 항상 라이트 모드로 렌더링
        case light
        /// 항상 다크 모드로 렌더링
        case dark
    }

    /// 사용할 열 수 설정
    public enum Width: Sendable {
        /// 뷰포트가 열 너비 결정
        case viewport
        /// 특정 수로 열 너비 설정
        case count(Int)
    }

    /// 내비게이션 항목의 수평 정렬 방식
    public enum ItemAlignment: String {
        /// 앞쪽 정렬
        case leading = ""
        /// 가운데 정렬
        case center = "justify-content-center"
        /// 뒤쪽 정렬
        case trailing = "justify-content-end"
        /// 기본값: 뒤쪽 정렬
        public static var automatic: Self { .trailing }
    }

    /// 내비게이션 메뉴 토글 버튼의 스타일
    public enum NavigationMenuStyle: Sendable {
        /// 테두리 없는 토글 버튼
        case plain
        /// 기본 테두리 스타일의 토글 버튼
        case bordered
        /// 기본 스타일
        public static var automatic: Self { .bordered }

        var styles: [InlineStyle] {
            switch self {
            case .plain: [.init(.border, value: "none")]
            case .bordered: []
            }
        }
    }

    /// 내비게이션 메뉴 토글에 사용할 아이콘
    public enum NavigationMenuIcon: String, Sendable {
        /// 햄버거 메뉴 아이콘 (가로선 3개)
        case bars = "navbar-toggler-icon"
        /// 점 3개 메뉴 아이콘
        case ellipsis = "bi bi-three-dots"
        /// 기본 아이콘
        public static var automatic: Self { .bars}
    }

    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 다양한 브레이크포인트에서 내리게이션 바 콘텐츠의 최대 너비를 제어합니다.
    private var widthClasses: [String] = ["container"]

    /// 토글 버튼에 표시할 아이콘
    private var toggleIcon: NavigationMenuIcon = .automatic

    /// 토글 버튼의 시각적 스타일
    private var toggleMenuStyle: NavigationMenuStyle = .automatic

    /// 사이트의 메인 로고. 클릭 시 홈페이지로 이동합니다.
    private let logo: any InlineElement

    /// 내비게이션 바에 표시할 항목 배열
    private let items: [any NavigationItem]

    /// 내비게이션 바 렌더링 스타일
    private var style = NavigationBarStyle.automatic

    /// 항목 정렬 방식
    private var itemAlignment = ItemAlignment.automatic

    /// `Spacer`가 아닌 보이는 컨트롤 수 (간격 클래스 결정에 사용)
    private var visibleControlCount: Int {
        items.filter {
            $0.navigationBarVisibility == .always &&
            $0.is(Spacer.self) == false
        }.count
    }

    /// 로고 없이 새 `NavigationBar` 인스턴스를 생성합니다.
    /// - Parameter logo: 바 왼쪽 상단에 사용할 로고
    public init(
        logo: (any InlineElement)? = nil
    ) {
        self.logo = logo ?? EmptyInlineElement()
        self.items = []
    }

    /// 로고와 항목들로 새 `NavigationBar` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - logo: 바 왼쪽 상단에 사용할 로고
    ///   - items: 작은 화면에서 햄버거 메뉴로 접힘되는 내비게이션 항목들
    public init(
        logo: (any InlineElement)? = nil,
        @ElementBuilder<NavigationItem> items: () -> [any NavigationItem]
    ) {
        self.logo = logo ?? EmptyInlineElement()
        self.items = items()
    }

    /// 항목들과 로고로 새 `NavigationBar` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - items: 내비게이션 항목들
    ///   - logo: 바 왼쪽 상단에 사용할 로고
    public init(
        @ElementBuilder<NavigationItem> items: () -> [any NavigationItem],
        @InlineElementBuilder logo: () -> any InlineElement = { EmptyInlineElement() }
    ) {
        self.items = items()
        self.logo = logo()
    }

    /// 내비게이션 바의 스타일을 조정합니다.
    /// - Parameter style: 새 스타일
    /// - Returns: 스타일이 업데이트된 새 `NavigationBar` 인스턴스
    public func navigationBarStyle(_ style: NavigationBarStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// 내비게이션 바 항목의 열 수를 조정합니다.
    /// - Parameter width: 새 열 수
    /// - Returns: 열 너비가 조정된 새 `NavigationBar` 인스턴스
    public func width(_ width: Width) -> Self {
        var copy = self
        switch width {
        case .viewport:
            copy.widthClasses = ["container-fluid", copy.columnWidth]
        case .count(let count):
            copy.columnWidth(.count(count))
            copy.widthClasses = ["container", copy.columnWidth]
        }
        return copy
    }

    /// 항목 정렬 방식을 조정합니다.
    /// - Parameter alignment: 새 정렬 방식
    /// - Returns: 정렬이 업데이트된 새 `NavigationBar` 인스턴스
    public func navigationItemAlignment(_ alignment: ItemAlignment) -> Self {
        var copy = self
        copy.itemAlignment = alignment
        return copy
    }

    /// 토글 버튼의 아이콘을 설정합니다.
    /// - Parameter icon: 토글 버튼에 사용할 아이콘
    /// - Returns: 아이콘이 업데이트된 새 `NavigationBar` 인스턴스
    public func navigationMenuIcon(_ icon: NavigationMenuIcon) -> Self {
        var copy = self
        copy.toggleIcon = icon
        return copy
    }

    /// 토글 버튼의 시각적 스타일을 설정합니다.
    /// - Parameter style: 토글 버튼에 적용할 스타일
    /// - Returns: 스타일이 업데이트된 새 `NavigationBar` 인스턴스
    public func navigationMenuStyle(_ style: NavigationMenuStyle) -> Self {
        var copy = self
        copy.toggleMenuStyle = style
        return copy
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] active 상태 자동 추적 없음. 필요시 `.class("active")`로 직접 추가.
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        // Use the child items directly so that types like Spacer() aren't concealed
        let items = items.flatMap { ($0 as? NavigationItemGroup)?.items ?? [$0] }
        let pinnedItems = items.filter { $0.navigationBarVisibility == .always }
        let collapsibleItems = items.filter { $0.navigationBarVisibility == .automatic }

        return Tag("header") {
            Tag("nav") {
                Section {
                    if logo.isEmpty == false {
                        Section(renderLogo(logo))
                            .class("me-2 me-md-auto")
                    }

                    if pinnedItems.isEmpty == false {
                        Section {
                            renderPinnedItems(pinnedItems)
                            if collapsibleItems.isEmpty == false {
                                // Keep the toggle button on the same line
                                // as the action items for a cleaner UI
                                renderToggleButton()
                            }
                        }
                        .class("flex-fill", "flex-md-grow-0", "flex-md-shrink-0")
                        .class("d-flex", "gap-2", "align-items-center", "justify-content-end")
                        .class(visibleControlCount > 1 ? nil : "gap-md-0")
                        .class("ms-auto")
                        .class("order-md-last")
                    }

                    if collapsibleItems.isEmpty == false {
                        if pinnedItems.isEmpty {
                            renderToggleButton()
                        }
                        renderCollapsibleItems(collapsibleItems)
                    }
                }
                .class(widthClasses)
                .class("flex-wrap flex-lg-nowrap")
            }
            .attributes(attributes)
            .class("navbar", "navbar-expand-md")
            .data("bs-theme", theme(for: style))
        }
        .markup()
    }

    private func renderPinnedItems(_ items: [any NavigationItem]) -> some HTML {
        ForEach(items) { item in
            if let item = item as? any NavigationItemConfigurable {
                AnyHTML(item.configuredAsNavigationItem(true))
            } else if let spacer = item.as(Spacer.self) {
                spacer.axis(.horizontal)
            } else {
                item
            }
        }
    }

    private func renderToggleButton() -> some InlineElement {
        Button {
            Span()
                .class(toggleIcon.rawValue)
        }
        .style(toggleMenuStyle.styles)
        .class("navbar-toggler")
        .data("bs-toggle", "collapse")
        .data("bs-target", "#navbarCollapse")
        .aria(.controls, "navbarCollapse")
        .aria(.expanded, "false")
        .aria(.label, "Toggle navigation")
    }

    private func renderCollapsibleItems(_ items: [any NavigationItem]) -> some HTML {
        Section {
            List {
                ForEach(items) { item in
                    switch item {
                    case let dropdownItem as Dropdown:
                        renderDropdownItem(dropdownItem)
                    case let link as Link:
                        renderLinkItem(link)
                    case let text as Span:
                        renderTextItem(text)
                    case let item as any NavigationItemConfigurable:
                        AnyHTML(item.configuredAsNavigationItem(true))
                    case let spacer as Spacer:
                        spacer.axis(.horizontal)
                    default:
                        AnyHTML(item)
                    }
                }
            }
            .class("navbar-nav", "mb-2", "mb-md-0", "col", itemAlignment.rawValue)
        }
        .class("collapse", "navbar-collapse")
        .id("navbarCollapse")
    }

    private func renderDropdownItem(_ dropdownItem: Dropdown) -> some HTML {
        ListItem {
            dropdownItem.configuration(.navigationBarItem)
        }
        .class("nav-item", "dropdown")
    }

    private func renderLinkItem(_ link: Link) -> some HTML {
        ListItem {
            link.trimmingMargin()
                .class(link.style == .button ? nil : "nav-link")
                .class("text-nowrap")
        }
        .class("nav-item")
    }

    private func renderTextItem(_ text: Span) -> some InlineElement {
        var text = text
        text.attributes.append(classes: "navbar-text")
        return text
    }

    private func renderLogo(_ logo: some InlineElement) -> any BodyElement {
        let logo: Link = if let link = logo.as(Link.self) {
            link
        } else {
            Link(logo, target: "/")
        }

        return logo
            .trimmingMargin()
            .class("d-inline-flex", "align-items-center")
            .class("navbar-brand")
    }

    private func theme(for style: NavigationBarStyle) -> String? {
        switch style {
        case .automatic: nil
        case .light: "light"
        case .dark: "dark"
        }
    }
}

fileprivate extension Link {
    func trimmingMargin() -> Self {
        guard content.is(Text.self) else { return self }
        var link = self
        var text = content
        text.attributes.append(classes: "mb-0")
        link.content = text
        return link
    }
}

fileprivate extension HTML {
    /// Adds a data attribute to the element.
    /// - Parameters:
    ///   - name: The name of the data attribute
    ///   - value: The value of the data attribute
    /// - Returns: The modified `HTML` element
    func data(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.attributes.append(dataAttributes: .init(name: name, value: value))
        return copy
    }
}
