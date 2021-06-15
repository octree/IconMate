import UIKit

struct AppIcon: Codable {
    struct Info: Codable {
        var author: String = "xcode"
        var version: Int = 1
    }
    enum Scale: String, Hashable, Codable {
        case one = "1x"
        case two = "2x"
        case three = "3x"

        var scale: Int {
            switch self {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
            }
        }
    }
    enum Idom: String, Codable {
        case iPhone = "iphone"
        case iPad = "ipad"
        case mac = "mac"
        case market = "ios-marketing"
    }

    enum ImageSize: String, Hashable, Codable {
        case pt20    =   "20x20"
        case pt29    =   "29x29"
        case pt40    =   "40x40"
        case pt60    =   "60x60"
        case pt76    =   "76x76"
        case pt83_5  =   "83.5x83.5"
        case pt1024  =   "1024x1024"
        case pt16    =   "16x16"
        case pt32    =   "32x32"
        case pt128   =   "128x128"
        case pt256   =   "256x256"
        case pt512   =   "512x512"
        static let macOnly: Set<ImageSize> = [.pt16, .pt32, .pt128, .pt256, .pt512]
        var isMacOnly: Bool {
            Self.macOnly.contains(self)
        }
    }

    struct Image: Codable {
        var filename: String
        var idiom: Idom
        var scale: Scale
        var size: ImageSize
    }
    var info: Info
    var images: [Image]
}

extension AppIcon.ImageSize {
    var width: CGFloat {
        switch self {
        case .pt20:
            return 20
        case .pt29:
            return 29
        case .pt40:
            return 40
        case .pt60:
            return 60
        case .pt76:
            return 76
        case .pt83_5:
            return 83.5
        case .pt1024:
            return 1024
        case .pt16:
            return 16
        case .pt32:
            return 32
        case .pt128:
            return 128
        case .pt256:
            return 256
        case .pt512:
            return 512
        }
    }
}

extension AppIcon.ImageSize {
    var fileName: String {
        switch self {
        case .pt83_5:
            return "83.5"
        default:
            return "\(Int(width))"
        }
    }
}

struct ScaleSize: Hashable {
    var size: AppIcon.ImageSize
    var scale: AppIcon.Scale
    var fileName: String {
        scale == .one ? "Icon-\(size.fileName).png" : "Icon-\(size.fileName)@\(scale.rawValue).png"
    }

    var isMacOnly: Bool { size.isMacOnly }
}

extension AppIcon.ImageSize {
    func scaleSizes(with scales: [AppIcon.Scale]) -> [ScaleSize] {
        scales.map { ScaleSize(size: self, scale: $0) }
    }
}

extension ScaleSize {
    var width: Int { Int(size.width * CGFloat(scale.scale)) }
    static var iPhoneScaleMap: [AppIcon.ImageSize: [AppIcon.Scale]] {
        [
            .pt20: [.two, .three],
            .pt29: [.two, .three],
            .pt40: [.two, .three],
            .pt60: [.two, .three],
        ]
    }

    static var iPadScaleMap: [AppIcon.ImageSize: [AppIcon.Scale]] {
        [
            .pt20: [.one, .two],
            .pt29: [.one, .two],
            .pt40: [.one, .two],
            .pt76: [.one, .two],
            .pt83_5: [.two]
        ]
    }

    static var macScaleMap: [AppIcon.ImageSize: [AppIcon.Scale]] {
        [
            .pt16: [.one, .two],
            .pt32: [.one, .two],
            .pt128: [.one, .two],
            .pt256: [.one, .two],
            .pt512: [.one, .two]
        ]
    }
    static let market: ScaleSize = ScaleSize(size: .pt1024, scale: .one)

    func image(for idom: AppIcon.Idom) -> AppIcon.Image {
        .init(filename: fileName, idiom: idom, scale: scale, size: size)
    }
}

extension Dictionary where Key == AppIcon.ImageSize, Value == [AppIcon.Scale] {
    var scaleSizes: [ScaleSize] {
        flatMap { (elt) -> [ScaleSize] in
            elt.value.map {
                ScaleSize(size: elt.key, scale: $0)
            }
        }
    }
}

extension Set where Element == ScaleSize {
    func resizedImages(for image: UIImage, mac: UIImage? = nil) -> [ScaleSize: UIImage] {
        let mac = mac ?? image
        var result = [ScaleSize: UIImage]()
        for size in self {
            if size.isMacOnly {
                result[size] = mac.resize(with: size)
            } else {
                result[size] = image.resize(with: size)
            }
        }
        return result
    }
}
