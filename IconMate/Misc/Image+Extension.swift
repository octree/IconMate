import CoreGraphics
import UIKit

extension CGImage {
    var removingAlphaChannel: CGImage {
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace!,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: context.width, height: context.height))
        return context.makeImage()!
    }

    func resized(width: Int, height: Int) -> CGImage {
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace!,
                                bitmapInfo: alphaInfo.rawValue)!
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        return context.makeImage()!
    }
}

extension UIImage {
    var removingAlphaChannel: UIImage { UIImage(cgImage: cgImage!.removingAlphaChannel) }
    func resize(width: Int, height: Int) -> UIImage {
        UIImage(cgImage: cgImage!.resized(width: width, height: height))
    }

    func resize(with scaleSize: ScaleSize) -> UIImage {
        resize(width: scaleSize.width, height: scaleSize.width)
    }
}
