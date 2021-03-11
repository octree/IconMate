import SwiftUI

struct ImageDropView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        HStack {
            ZStack {
                VStack(spacing: 12) {
                    Image.plus
                    Text("Drag")
                }.font(.title)
                .foregroundColor(.secondaryLabel)
                if let image = viewModel.image {
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

