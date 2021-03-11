import Foundation
import UIKit
import SwiftUI
import UniformTypeIdentifiers
import MobileCoreServices

class HomeViewModel: ObservableObject {
    @Published var iphone: Bool = true
    @Published var iPad: Bool = true
    @Published var mac: Bool = false
    @Published var market: Bool = true
    @Published var image: UIImage?

    private func allImageInfoAndSizes() -> ([AppIcon.Image], Set<ScaleSize>) {
        var images = [AppIcon.Image]()
        var sizes = Set<ScaleSize>()
        if iphone {
            let size = ScaleSize.iPhoneScaleMap.scaleSizes
            images.append(contentsOf: size.map({ $0.image(for: .iPhone) }))
            size.forEach { sizes.insert($0) }
        }
        if iPad {
            let size = ScaleSize.iPadScaleMap.scaleSizes
            images.append(contentsOf: size.map({ $0.image(for: .iPad) }))
            size.forEach { sizes.insert($0) }
        }
        if mac {
            let size = ScaleSize.macScaleMap.scaleSizes
            images.append(contentsOf: size.map({ $0.image(for: .mac) }))
            size.forEach { sizes.insert($0) }
        }
        if market {
            images.append(ScaleSize.market.image(for: .market))
            sizes.insert(ScaleSize.market)
        }

        return (images, sizes)
    }

    func onSave() {
        guard let vc = UIApplication.shared.activeWindow?.rootViewController else {
            return
        }
        let picker = DocumentPickerViewController(supportedTypes: [kUTTypeFolder as String], mode: .open) { [weak self] urls in
            guard let url = urls.first else {
                return
            }
            self?.saveAppIcon(to: url)
        }
        vc.present(picker, animated: true, completion: nil)
    }

    private func saveAppIcon(to url: URL) {
        guard let image = self.image?.removingAlphaChannel else {
            return
        }
        let (imageInfos, sizes) = allImageInfoAndSizes()
        let imageMap = sizes.resizedImages(for: image)
        let root = FS.Path(url.path) + "AppIcon.appiconset"
        let info = AppIcon(info: .init(), images: imageInfos)
        do {
            try root.mkdir()
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(info)
            try (root + "Contents.json").write(data)
            try imageMap.forEach { (key, value) in
                try (root + key.fileName).write(value.pngData()!)
            }
        } catch {
            print(error)
        }
    }
}

extension HomeViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        return info.itemProviders(for: [.png])
            .loadFirstObject(ofType: UIImage.self) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
        }
    }
}

