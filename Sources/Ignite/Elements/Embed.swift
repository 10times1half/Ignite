//
// Embed.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//

import Foundation

/// YouTube, Vimeo, Spotify 등 외부 URL을 페이지에 임베드합니다.
public struct Embed: HTML, LazyLoadable {
    /// Spotify 임베드 콘텐츠 유형
    public enum SpotifyContentType: String {
        /// 단일 Spotify 트랙
        case track
        /// Spotify 플레이리스트
        case playlist
        /// Spotify 아티스트
        case artist
        /// Spotify 앨범
        case album
        /// Spotify 팟캐스트
        case show
        /// Spotify 에피소드
        case episode
    }

    /// 이 HTML의 콘텐츠와 동작
    public var body: some HTML { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 페이지에 임베드할 URL
    let url: String

    /// 이 콘텐츠를 설명하는 제목 (스크린 리더용)
    let title: String

    /// 제목과 URL로 새 `Embed` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - title: 스크린 리더용 제목
    ///   - url: 임베드할 URL
    public init(title: String, url: URL) {
        self.url = url.absoluteString
        self.title = title
    }

    /// 제목과 URL 문자열로 새 `Embed` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - title: 스크린 리더용 제목
    ///   - url: 임베드할 URL 문자열
    public init(title: String, url: String) {
        self.url = url
        self.title = title
    }

    /// Vimeo ID로 새 `Embed` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - vimeoID: Vimeo 비디오 ID
    ///   - title: 스크린 리더용 제목
    public init(vimeoID: Int, title: String) {
        if let test = URL(string: "https://player.vimeo.com/video/\(vimeoID)") {
            self.url = test.absoluteString
            self.title = String(title)
        } else {
            fatalError("Failed to create Vimeo URL from video ID: \(vimeoID).")
        }
    }

    /// YouTube ID로 새 `Embed` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - youTubeID: YouTube 비디오 ID
    ///   - title: 스크린 리더용 제목
    public init(youTubeID: String, title: String) {
        if let test = URL(string: "https://www.youtube-nocookie.com/embed/\(youTubeID)") {
            self.url = test.absoluteString
            self.title = title
        } else {
            fatalError("Failed to create YouTube URL from video ID: \(youTubeID).")
        }
    }

    /// Spotify ID로 새 `Embed` 인스턴스를 생성합니다.
    /// - Parameters:
    ///   - spotifyID: Spotify 콘텐츠 ID
    ///   - title: 스크린 리더용 제목
    ///   - type: Spotify 콘텐츠 유형
    ///   - theme: Spotify 테마 (0 또는 1)
    public init(spotifyID: String, title: String, type: SpotifyContentType = .track, theme: Int = 0) {
        if let test = URL(
            string: "https://open.spotify.com/embed/\(type.rawValue)/\(spotifyID)?utm_source=generator&theme=\(theme)"
        ) {
            self.url = test.absoluteString
            self.title = title
        } else {
            fatalError("Failed to create Spotify URL from ID: \(spotifyID).")
        }
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        // 사용자가 일반적인 작업을 안전하게 수행할 수 있는 충분한 권한
        let allowPermissions = """
            accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share
            """

        return Section {
             #"<iframe src="\#(url)" title="\#(title)" allow="\#(allowPermissions)"></iframe>"#
        }
        .attributes(attributes)
        .markup()
    }
}
