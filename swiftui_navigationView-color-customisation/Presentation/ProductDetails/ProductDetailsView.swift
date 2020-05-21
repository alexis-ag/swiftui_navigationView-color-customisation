import SwiftUI

struct ProductDetailsView: View {
    let props: ProductDetailsViewProps

    var body: some View {
        self.details(props.model)
            .navigationBarTitle("Product details", displayMode: .inline)
    }

    private func details(_ model: ProductViewModel) -> some View {
        ScrollView {
            Text("Product: \(model.title)")
                .padding()

            Button(action: self.props.onBuy) {
                Text("Buy it!")
                    .font(.largeTitle)
            }
                .padding()

            /*todo ATTENTION!
                you can get accentColor from the static method of Color object
            */
            Text("Accent color in use: productId: ") +
                    Text("\(model.id)")
                            .foregroundColor(Color.accentColor)
        }
    }
}