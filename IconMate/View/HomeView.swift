import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(spacing: 32) {
            TextField("AppIcon", text: viewModel.binding(\.name))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 200)
            ImageDropView(viewModel: viewModel)
            if viewModel.image != nil {
                VStack(spacing: 16) {
                    Toggle("iPhone", isOn: viewModel.binding(\.iPhone))
                    Toggle("iPad", isOn: viewModel.binding(\.iPad))
                    Toggle("Mac", isOn: viewModel.binding(\.mac))
                    Toggle("iOS Marketing", isOn: viewModel.binding(\.market))
                    Toggle("Remove Alpha Channel", isOn: viewModel.binding(\.removeAlpha))
                }
                Button {
                    viewModel.onSave()
                } label: {
                    Text("Save")
                        .frame(width: 200, height: 48)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color(UIColor.systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            Spacer()
        }.padding(EdgeInsets(top: 60, leading: 80, bottom: 60, trailing: 80))
        .background(Color.background)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
