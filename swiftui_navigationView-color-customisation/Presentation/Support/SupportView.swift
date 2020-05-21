import SwiftUI

struct SupportView: View {
    let props: SupportViewProps

    var body: some View {
        ScrollView {
            Text("Support content")
                    .navigationBarTitle("Support")
        }
    }
}