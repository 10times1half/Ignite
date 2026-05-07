//
// Audio.swift
// Ignite (KalSae HTML-Only Fork)
// 원본: https://www.github.com/twostraws/Ignite
// 라이선스: MIT (LICENSE 참조)
//
// [KalSae 포크 변경] publishingContext.addWarning() 호출 제거
//

/// 페이지에 오디오를 재생합니다.
public struct Audio: InlineElement, LazyLoadable {
    /// 이 HTML의 콘텐츠와 동작
    public var body: some InlineElement { self }

    /// HTML 요소의 표준 제어 속성 집합
    public var attributes = CoreAttributes()

    /// 이 HTML이 프레임워크에 속하는지 여부
    public var isPrimitive: Bool { true }

    /// 재생할 오디오 파일 경로 배열 (예: /audio/bark.mp3)
    private var files: [String]?

    /// 사이트 에셋 내 오디오 파일로 `Audio` 인스턴스를 생성합니다.
    /// - Parameter files: 사이트 루트 기준 상대 경로 (예: /audio/bark.mp3)
    public init(_ files: String...) {
        self.files = files
    }

    /// 오디오 파일들을 HTML로 렌더링합니다.
    /// - Parameter files: 렌더링할 오디오 파일 경로 배열
    /// - Returns: 이 요소의 HTML
    private func render(files: [String]) -> Markup {
        var output = ""

        for filename in files {
            if let fileType = audioType(for: filename) {
                output += "<source src=\"\(filename)\" type=\"\(fileType.mimeType)\">"
            }
        }

        output += "Your browser does not support the audio element."
        return Markup("<audio controls\(attributes)>\(output)</audio>")
    }

    /// 이 요소를 HTML 마크업으로 렌더링합니다.
    /// [KalSae 포크] 파일이 없으면 빈 Markup을 반환합니다 (경고 없음).
    /// - Returns: 이 요소의 HTML
    public func markup() -> Markup {
        guard let files = files else {
            return Markup()
        }

        return render(files: files)
    }

    // 파일 확장자 → AudioType 매핑 딕셔너리
    let audioTypeMapping: [String: AudioType] = [
        ".aac": .aac,
        ".aifc": .aifc,
        ".aif": .aif,
        ".au": .au, ".snd": .au,
        ".flac": .flac,
        ".funk": .funk, ".my": .funk, ".pfunk": .funk,
        ".gsd": .gsd, ".gsm": .gsd,
        ".it": .it,
        ".jam": .jam,
        ".kar": .kar, ".mid": .kar,
        ".la": .la, ".lma": .la,
        ".lam": .lam,
        ".m3u": .m3u,
        ".mka": .mka,
        ".mod": .mod,
        ".mp2": .mp2, ".m2a": .mp2,
        ".mp3": .mp3,
        ".mp4": .m4a,
        ".midi": .midi,
        ".mjf": .mjf,
        ".midX": .midX,
        ".ogg": .ogg,
        ".opus": .opus,
        ".pfunkMyFunk": .pfunkMyFunk,
        ".qcp": .qcp,
        ".ra": .ra, ".ram": .ra, ".rm": .ra, ".rmm": .ra, ".rmp": .ra,
        ".raPlugin": .raPlugin, ".rmpPlugin": .raPlugin, ".rpm": .raPlugin,
        ".rmi": .rmi,
        ".s3m": .s3m,
        ".sid": .sid,
        ".sndX": .sndX,
        ".tsi": .tsi, ".tsp": .tsi,
        ".voc": .voc,
        ".vox": .vox,
        ".vqe": .vqe, ".vql": .vql,
        ".vqf": .vqf,
        ".wav": .wav, ".wavX": .wavX,
        "webm": .webm,
        ".xm": .xm
    ]
}

public extension Audio {
    /// `AudioType` is an enumeration that defines a list of audio file types.
    /// Each case in the enum represents a different audio format, and the
    /// raw value of each case is the MIME type associated with that format.
    enum AudioType {
        /// - aac: Advanced Audio Coding
        /// Known for its efficiency and quality, often used in Apple products.
        case aac

        /// - aif: Audio Interchange File Format
        /// Standard audio format used by Apple. It stores sound data
        /// for personal computers and other electronic audio devices.
        case aif

        /// - aifc: Compressed Audio Interchange File
        /// Similar to AIFF but compressed using various codecs.
        case aifc

        /// - au, snd: Basic Audio
        /// The standard audio format for Unix-based systems.
        case au, snd // swiftlint:disable:this identifier_name

        /// - flac: Free Lossless Audio Codec
        /// A lossless compression for audio files.
        case flac

        /// - funk, my, pfunk: Funk Sound
        /// A playful or proprietary audio format typically used for making
        /// fun or funky sounds.
        case funk, my, pfunk // swiftlint:disable:this identifier_name

        /// - gsd, gsm: GSM Audio
        /// Audio format for Global System for Mobile Communications.
        case gsd, gsm

        /// - it: Impulse Tracker Module
        /// Audio file format for Impulse Tracker, a sequencer music editor.
        case it // swiftlint:disable:this identifier_name

        /// - jam: Jam Music File
        /// A file format typically associated with a music application called Jam.
        case jam

        /// - kar, mid: MIDI Sound
        /// Musical Instrument Digital Interface; a standard for digital music instruments.
        case kar, mid

        /// - la, lma: NSP Audio
        /// Audio format used by the Unix-based NeXTSTEP operating system.
        case la, lma // swiftlint:disable:this identifier_name

        /// - laX, lmaX: Extended NSP Audio
        /// Extended version of the NSP audio format.
        case laX, lmaX

        /// - lam: Live Audio Media
        /// An audio streaming format.
        case lam

        /// - m3u: MP3 Playlist File
        /// File format used for multimedia playlists.
        case m3u

        /// - m4a: MPEG-4 Audio
        /// Commonly used for audio books and podcasts.
        case m4a

        /// - midX: Extended MIDI File
        /// An extended version of the standard MIDI audio format.
        case midX

        /// - midi: MIDI File
        /// Standard MIDI (Musical Instrument Digital Interface) file format.
        case midi

        /// - mjf: MJuice Media File
        /// Proprietary audio format used by MJuice media player.
        case mjf

        /// - mka: Matroska Audio File
        /// An audio container format that can hold various audio codecs.
        case mka

        /// - mod: MOD Audio
        /// Audio file format used with Amiga and PC trackers.
        case mod

        /// - modX: Extended MOD Audio
        /// An extended version of the MOD audio format.
        case modX

        /// - mp2, m2a, mp2X: Extended MPEG Audio
        /// An extended version of the MPEG audio format.
        case mp2, m2a, mp2X

        /// - mp3, mpa, mpg, mpga, mp3Mpeg3, mp3X: MPEG-3 Audio
        /// Audio layer 3 of the MPEG standard.
        case mp3, mpa, mpg, mpga, mp3Mpeg3, mp3X

        /// - ogg: Ogg Vorbis
        /// Often used for streaming audio.
        case ogg

        /// - opus: Opus Audio Codec
        /// Known for its low latency and versatility in various applications.
        case opus

        /// - pfunkMyFunk: Make My Funk Audio
        /// A proprietary or playful audio format for funky sounds.
        case pfunkMyFunk

        /// - qcp: Qualcomm PureVoice Audio
        /// Audio format used for recording human speech.
        case qcp

        /// - ra, ram, rm, rmm, rmp, raReal: RealAudio
        /// Audio format developed by RealNetworks for streaming audio over the internet.
        case ra, ram, rm, rmm, rmp, raReal // swiftlint:disable:this identifier_name

        /// - raPlugin, rmpPlugin, rpm: RealAudio Plugin
        /// Extension for RealAudio to be used with browser plugins.
        case raPlugin, rmpPlugin, rpm

        /// - rmi: MIDI File for Windows
        /// A MIDI file format used by Windows operating systems.
        case rmi

        /// - s3m: ScreamTracker 3 Module
        /// Audio file format used by ScreamTracker.
        case s3m

        /// - sid: Commodore 64 SID Music
        /// Audio file format used to store music created for the Commodore 64 SID chip.
        case sid

        /// - sndX: Extended ADPCM Audio
        /// An extended version of the Adaptive Differential Pulse-Code Modulation audio format.
        case sndX

        /// - tsp, tsi: TSP Audio
        /// Audio format for the TrueSpeech Player.
        case tsp, tsi

        /// - voc, vocX: Creative Labs Audio File
        /// Audio file format used by Creative Labs hardware.
        case voc, vocX

        /// - vox: Voxware Audio File
        /// Audio format used by Voxware applications.
        case vox

        /// - vqe, vql: TwinVQ Plugin Audio
        /// Audio format used by TwinVQ for browser plugins.
        case vqe, vql

        /// - vqf: TwinVQ Audio File
        /// Audio file format developed by NTT for compressed audio.
        case vqf

        /// - wav, wavX: Extended WAV Audio
        /// An extended version of the WAV audio format.
        case wav, wavX

        /// - webm: WebM Audio
        /// Designed for use in HTML5 web browsers.
        case webm

        /// - xm: Extended Module
        /// Audio file format used by various tracker software.
        case xm // swiftlint:disable:this identifier_name

        var mimeType: String {
            switch self {
            case .aac: "audio/aac"
            case .aif: "audio/aiff"
            case .aifc: "audio/x-aiff"
            case .au, .snd: "audio/basic"
            case .flac: "audio/flac"
            case .funk, .my, .pfunk: "audio/make"
            case .gsd, .gsm: "audio/x-gsm"
            case .it: "audio/it"
            case .jam: "audio/x-jam"
            case .kar, .mid: "audio/midi"
            case .la, .lma: "audio/nspaudio"
            case .laX, .lmaX: "audio/x-nspaudio"
            case .lam: "audio/x-liveaudio"
            case .m3u: "audio/x-mpequrl"
            case .m4a: "audio/mp4"
            case .midX: "audio/x-mid"
            case .midi: "audio/x-midi"
            case .mjf: "audio/x-vnd.audioexplosion.mjuicemediafile"
            case .mka: "audio/x-matroska"
            case .mod: "audio/mod"
            case .modX: "audio/x-mod"
            case .mp2, .m2a, .mp2X: "audio/x-mpeg"
            case .mp3, .mpa, .mpg, .mpga, .mp3Mpeg3, .mp3X: "audio/mpeg"
            case .ogg: "audio/ogg"
            case .opus: "audio/opus"
            case .pfunkMyFunk: "audio/make.my.funk"
            case .qcp: "audio/vnd.qcelp"
            case .ra, .ram, .rm, .rmm, .rmp, .raReal: "audio/x-pn-realaudio"
            case .raPlugin, .rmpPlugin, .rpm: "audio/x-pn-realaudio-plugin"
            case .rmi: "audio/mid"
            case .s3m: "audio/s3m"
            case .sid: "audio/x-psid"
            case .sndX: "audio/x-adpcm"
            case .tsp, .tsi: "audio/tsplayer"
            case .voc, .vocX: "audio/x-voc"
            case .vox: "audio/voxware"
            case .vqe, .vql: "audio/x-twinvq-plugin"
            case .vqf: "audio/x-twinvq"
            case .wav, .wavX: "audio/wav"
            case .webm: "audio/webm"
            case .xm: "audio/xm"
            }
        }
    }

    /// Determines the audio file type based on the file extension present in the filename.
    /// - Parameter filename: The name of the file, including its extension.
    /// - Returns: An optional `AudioType` corresponding to the file extension.
    ///            Returns `nil` if the extension does not match any known audio types.

    func audioType(for filename: String) -> AudioType? {
        audioTypeMapping.first { filename.contains($0.key) }?.value
    }
}
