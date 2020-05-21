import SwiftUI

struct OrderDetailsView: View {
    let props: OrderDetailsViewProps

    var body: some View {
        Text("OrderDetails: \(props.model.title)")
            .navigationBarTitle("Order details", displayMode: .inline)
    }
}