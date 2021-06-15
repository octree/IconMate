import Foundation
import UIKit
import SwiftUI
import UniformTypeIdentifiers
import MobileCoreServices

private func _binding<T, V>(target: T, path: ReferenceWritableKeyPath<T, V>) -> Binding<V> {
    .init {
        target[keyPath: path]
    } set: { newValue in
        target[keyPath: path] = newValue
    }
}

class HomeViewModel: ObservableObject {
    @Published var iPhone: Bool = true
    @Published var iPad: Bool = true
    @Published var mac: Bool = false
    @Published var market: Bool = true
    @Published var removeAlpha: Bool = true
    @Published var image: UIImage?
    @Published var macImage: UIImage?
    @Published var name: String = "AppIcon"

    private func allImageInfoAndSizes() -> ([AppIcon.Image], Set<ScaleSize>) {
        var images = [AppIcon.Image]()
        var sizes = Set<ScaleSize>()
        if iPhone {
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
        guard let image = removeAlpha ?  self.image?.removingAlphaChannel : self.image else {
            return
        }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let fileName = trimmed.count > 0 ? trimmed : "AppIcon"
        let (imageInfos, sizes) = allImageInfoAndSizes()
        let imageMap = sizes.resizedImages(for: image, mac: macImage)
        let root = FS.Path(url.path) + "\(fileName).appiconset"
        let info = AppIcon(info: .init(), images: imageInfos)
        do {
            if root.exists {
                try root.delete()
            }
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
    
    func binding<V>(_ path: ReferenceWritableKeyPath<HomeViewModel, V>) -> Binding<V> {
        _binding(target: self, path: path)
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

