import SwiftUI

private class ImageDropViewModel: ObservableObject {
    var image: Binding<UIImage?>
    init(image: Binding<UIImage?>) {
        self.image = image
    }
}

extension ImageDropViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        return info.itemProviders(for: [.png])
            .loadFirstObject(ofType: UIImage.self) { image in
                DispatchQueue.main.async {
                    self.image.wrappedValue = image
                }
        }
    }
}

struct ImageDropView: View {
    @StateObject private var viewModel: ImageDropViewModel
    @Binding var image: UIImage?
    var title: String
    init(image: Binding<UIImage?>, title: String) {
        self.title = title
        _image = image
        _viewModel = .init(wrappedValue: .init(image: image))
    }
    var body: some View {
        HStack {
            ZStack {
                VStack(spacing: 12) {
                    Image.plus
                    Text(title)
                }.font(.title)
                .foregroundColor(.secondaryLabel)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }.frame(width: 260, height: 260)
        .background(Color.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
        .shadow(color: Color.gray.opacity(0.6), radius: 6, x: 1, y: 2)
        .onDrop(of: [.png], delegate: viewModel)
    }
}

