import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    private var iPhoneBinding: Binding<Bool> {
        .init {
            viewModel.iphone
        } set: { newValue in
            viewModel.iphone = newValue
        }
    }

    private var iPadBinding: Binding<Bool> {
        .init {
            viewModel.iPad
        } set: { newValue in
            viewModel.iPad = newValue
        }
    }

    private var macBinding: Binding<Bool> {
        .init {
            viewModel.mac
        } set: { newValue in
            viewModel.mac = newValue
        }
    }

    private var marketBinding: Binding<Bool> {
        .init {
            viewModel.market
        } set: { newValue in
            viewModel.market = newValue
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            ImageDropView(viewModel: viewModel)
            if viewModel.image != nil {
                VStack(spacing: 16) {
                    Toggle("iPhone", isOn: iPhoneBinding)
                    Toggle("iPad", isOn: iPadBinding)
                    Toggle("Mac", isOn: macBinding)
                    Toggle("iOS Marketing", isOn: marketBinding)
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
