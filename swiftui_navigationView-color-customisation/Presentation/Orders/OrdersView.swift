import SwiftUI

struct OrdersView: View {
    let props: OrdersViewProps

    var body: some View {
        self.orderList(self.props.models)
            .navigationBarTitle("Orders")
    }

    private func orderList(_ models: [OrderViewModel]) -> some View {
        List(props.models) { model in
            self.orderRow(model)
        }
    }

    private func orderRow(_ model: OrderViewModel) -> some View{
        let dateStr = model.date.toString(as: DateFormat.defaultDate)
        let timeStr = model.date.toString(as: DateFormat.defaultTime)

        return NavigationLink(
                destination: OrderDetailsView(
                        props: OrderDetailsViewProps(model: model)
                )
        ) {
            VStack(alignment: .leading) {
                Text("Order: \(model.title) at: \(dateStr) \(timeStr)")
                Text("code: \(String(model.id.suffix(5)))")
            }
        }
    }
}