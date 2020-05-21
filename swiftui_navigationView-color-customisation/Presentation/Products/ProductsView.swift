import SwiftUI

struct ProductsView: View {
    let props: ProductsViewProps

    var body: some View {
        self.productList(self.props.models)
            .navigationBarTitle("Products")
                .navigationBarItems(
                        trailing: self.sayHiBtn
                )
    }

    private func productList(_ models: [ProductViewModel]) -> some View {
        List(props.models) { model in
            self.productRow(model)
        }
    }

    private func productRow(_ model: ProductViewModel) -> some View {
        NavigationLink(
                destination: ProductDetailsView(
                        props: ProductDetailsViewProps(
                                model: model,
                                onBuy: { self.props.onBuy(model.id) }
                        )
                )
        ) {
            Text(model.title)
        }
    }

    private var sayHiBtn: some View {
        Button(action: { print("HI") }) {
            Text("print HI")
        }
    }
}