//
// Video.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] publishingContext.addWarning() 호출 제거
//

/// 페이지에 비디오 플레이어를 표시합니다.
public struct Video: InlineElement, LazyLoadable {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some InlineElement { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 재생할 비디오 파일 경로 배열 (예: /video/outforwalk.mp4)
    private var files: [String]?

    /// 사이트 에셋 내 비디오 파일로 `Video` 인스턴스를 생성합니다.
    /// - Parameter files: 사이트 루트 기준 상대 경로 (예: /video/outforwalk.mp4)
    public init(_ files: String...) {
        self.files = files
    }

    /// 비디오 파일들을 HTML로 렌더링합니다.
    /// - Parameter files: 렌더링할 비디오 파일 경로 배열
    /// - Returns: 이 요소의 HTML
    private func render(files: [String]) -> Markup {
        var output = "<video controls\(attributes)>"

        for filename in files {
            if let fileType = videoType(for: filename) {
                output += "<source src=\"\(filename)\" type=\"\(fileType.rawValue)\" />"
            }
        }

        output += "Your browser does not support the video tag."
        output += "</video>"
        return Markup(output)
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] 파일이 없으면 빈 Markup을 반환합니다 (경고 없음).
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        guard let files = self.files else {
            return Markup()
        }
        return render(files: files)
    }

    // 파일 확장자 → VideoType 매핑 딕셔너리
    let videoTypeDictionary: [String: VideoType] = [
        ".animaflex": .animaflex,
        ".asfplugin": .asfPlugin,
        ".asf": .asf,
        ".atomic3dfeature": .atomic3dFeature,
        ".avi": .avi,
        ".avs": .avsVideo,
        ".av1": .av1,
        ".dv": .dv,
        ".fli": .fli,
        ".flv": .flv,
        ".gl": .gl,
        ".h264": .h264,
        ".mp4": .h264,
        ".h265": .h265,
        ".hevc": .h265,
        ".isvideo": .isvideo,
        ".matroska": .matroska,
        ".mkv": .matroska,
        ".motionjpeg": .motionJpeg,
        ".mpeg": .mpeg,
        ".mp2t": .mp2t,
        ".ogg": .ogg,
        ".quicktime": .quicktime,
        ".mov": .quicktime,
        ".rnrealvideo": .rnRealvideo,
        ".sgimovie": .sgiMovie,
        ".scm": .scm,
        ".vdo": .vdo,
        ".vivo": .vivo,
        ".vp9": .vp9,
        ".vosaic": .vosaic,
        ".webm": .webm
    ]

}

extension Video {
    /// `VideoType` is an enumeration that defines a list of video
    /// file types. Each case in the enum represents a different video
    /// format, and the raw value of each case is the MIME type associated
    /// with that format.
    public enum VideoType: String {
        /// - animaflex: Animaflex Format
        /// A video format with the MIME type 'video/animaflex'.
        case animaflex = "video/animaflex"

        /// - asf: Advanced Systems Format
        /// A Microsoft streaming format supported by Windows Media Player.
        case asf = "video/x-ms-asf"

        /// - asfPlugin: ASF Plugin Format
        /// A variant of the ASF format used with browser plugins.
        case asfPlugin = "video/x-ms-asf-plugin"

        /// - atomic3dFeature: Atomic3D Feature Format
        /// A video format used for 3D feature films.
        case atomic3dFeature = "video/x-atomic3d-feature"

        /// - avi: Audio Video Interleave
        /// A popular video format supported by many players and platforms.
        case avi = "video/avi"

        /// - avsVideo: AVS Video Format
        /// A format used for AVS video files.
        case avsVideo = "video/avs-video"

        /// - av1: AOMedia Video 1
        /// A cutting-edge codec known for its efficiency and open-source status.
        case av1 = "video/av1"

        /// - dv: Digital Video Format
        /// A digital video format used in digital camcorders.
        case dv = "video/x-dv" // swiftlint:disable:this identifier_name

        /// - fli: FLI Animation Format
        /// An animation format capable of storing short animations.
        case fli = "video/fli"

        /// - flv: Flash Video Format
        /// Used by Adobe Flash Player and other applications for streaming video over the internet.
        case flv = "video/x-flv"

        /// - gl: GL Animation Format
        /// A video format used for GL animations.
        case gl = "video/gl" // swiftlint:disable:this identifier_name

        /// - h264: H.264 Video Format
        /// Commonly used for high-definition video in MP4 containers.
        case h264 = "video/mp4"

        /// - h265: High Efficiency Video Coding (HEVC)
        /// Known for its improved compression over H.264.
        case h265 = "video/hevc"

        /// - isvideo: ISVIDEO Format
        /// A format used for IS video files.
        case isvideo = "video/x-isvideo"

        /// - matroska: Matroska Format
        /// A modern container format capable of holding an unlimited
        /// number of video, audio, picture, or subtitle tracks in one file.
        case matroska = "video/x-matroska"

        /// - motionJpeg: Motion JPEG Format
        /// A video format where each video frame is separately
        /// compressed as a JPEG image.
        case motionJpeg = "video/x-motion-jpeg"

        /// - mpeg: MPEG Video Format
        /// A standard for lossy compression of video and audio.
        case mpeg = "video/mpeg"

        /// - mp2t: MP2T Streaming Format
        /// A video streaming format used for broadcasting over the internet.
        case mp2t = "video/mp2t"

        /// - ogg: Ogg Video Format
        /// Often used for embedding video on web pages with HTML5.
        case ogg = "video/ogg"

        /// - quicktime: QuickTime Format
        /// Used primarily for Apple's QuickTime Player.
        case quicktime = "video/quicktime"

        /// - rnRealvideo: RN Realvideo Format
        /// A proprietary video format developed by RealNetworks.
        case rnRealvideo = "video/vnd.rn-realvideo"

        /// - sgiMovie: SGI Movie Format
        /// A video format developed by Silicon Graphics.
        case sgiMovie = "video/x-sgi-movie"

        /// - scm: SCM Video Format
        /// A video format used for SCM video files.
        case scm = "video/x-scm"

        /// - vdo: VDO Video Format
        /// A video format used for VDO files.
        case vdo = "video/vdo"

        /// - vivo: Vivo Video Format
        /// A video format developed by Vivo Software.
        case vivo = "video/vnd.vivo"

        /// - vp9: VP9 Video Format
        /// An open-source codec developed by Google.
        case vp9 = "video/vp9"

        /// - vosaic: Vosaic Video Format
        /// A video format used for Vosaic files.
        case vosaic = "video/vosaic"

        /// - webm: WebM Video Format
        /// Designed for use in HTML5 web browsers.
        case webm = "video/webm"
    }

    /// Determines the video file type based on the file extension present in the filename.
    /// - Parameter filename: The name of the file, including its extension.
    /// - Returns: An optional `VideoType` corresponding to the file extension.
    ///            Returns `nil` if the extension does not match any known video types.
    public func videoType(for filename: String) -> VideoType? {
        for (fileExtension, type) in videoTypeDictionary where filename.contains(fileExtension) {
            return type
        }
        return nil
    }
}
