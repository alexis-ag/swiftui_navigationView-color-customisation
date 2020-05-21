import SwiftUI

enum NavigationItem: Int {
    case products = 0
    case orders = 1
    case support = 2
}

struct ContentContainer: View {
    @State private var products = [
        Product(id: 1, name: "Banana", type: .food, price: 0.5, currency: .usd),
        Product(id: 2, name: "TV", type: .nonFood, price: 100.5, currency: .usd),
        Product(id: 3, name: "Camera", type: .nonFood, price: 50.5, currency: .usd)
    ]
    @State private var orders: [Order] = []
    @State private  var selectedTap = NavigationItem.products

    private let productColorScheme = ColorScheme(
            navBarTintColor: .red,
            navBarBgColor: .yellow,
            accentColor: .orange
    )
    private let orderColorScheme = ColorScheme(
            navBarTintColor: .white,
            navBarBgColor: .black,
            accentColor: .gray
    )

    var body: some View {
        TabView(selection: $selectedTap) {
            NavigationView {
                self.productsContent(self.products)
            }
                    /* todo ATTENTION!
                        it changes accent color in all entire view hierarchy
                    */
                    .accentColor(self.productColorScheme.accentColor)
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Products")
                    }.tag(NavigationItem.products)
                    .onAppear {
                        /* todo ATTENTION! it's really meaningful where you try to apply navBar customisation
                            you have to do it
                            * onAppear on NavigationView
                            * on view with NavigationView init()
                            ** but if you have EnvironmentObject you can't do your own init() constructor
                            * in body before view return
                       */
                        self.customiseNavBar(
                                accentColor: self.productColorScheme.navBarTintColor,
                                backgroundColor: self.productColorScheme.navBarBgColor
                        )
                    }
                    .onDisappear {
                        /*todo CAUTION!
                            if you changed appearance of NavBar
                            you really need to reset it to default on new view onAppear
                            or on previous view onDisappear
                        */
                        self.resetNavBarCustomisation()
                    }

            NavigationView {
                self.ordersContent(self.orders)
            }
                    .accentColor(self.orderColorScheme.accentColor)
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Orders")
                    }.tag(NavigationItem.orders)
                    .onAppear {
                        self.customiseNavBar(
                                accentColor: self.orderColorScheme.navBarTintColor,
                                backgroundColor: self.orderColorScheme.navBarBgColor
                        )
                    }
                    .onDisappear {
                        self.resetNavBarCustomisation()
                    }

            NavigationView {
                self.supportContent()
            }
                    .accentColor(self.orderColorScheme.accentColor)
                    .tabItem {
                        Image(systemName: "message")
                        Text("Support")
                    }.tag(NavigationItem.support)
        }
    }

    private func productsContent(_ products: [Product]) -> some View {
        ProductsView(
                props: ProductsViewProps(
                        models: self.products.map { ProductViewModel(id: $0.id, title: $0.name) },
                        onBuy: self.onBuyProduct
                )
        )
    }

    private func ordersContent(_ products: [Order]) -> some View {
        OrdersView(
                props: OrdersViewProps(
                        models: self.orders.map { OrderViewModel(id: $0.id, title: $0.name, date: $0.date) }
                )
        )
    }

    private func supportContent() -> some View {
        SupportView(
                props: SupportViewProps()
        )
    }

    private func onBuyProduct(_ id: Int) {
        let newOrder =
                self.products
                    .filter { $0.id == id }
                    .map {
                        Order(
                                id: UUID().uuidString,
                                name: $0.name,
                                date: Date()
                        )
                    }
                    .first

        guard let order = newOrder else {
            //handle error
            return
        }
        self.orders.append(order)
        self.selectedTap = .orders
    }

    private func resetNavBarCustomisation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [:]
        appearance.largeTitleTextAttributes = [:]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .systemBlue
    }

    private func customiseNavBar(accentColor: UIColor, backgroundColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: accentColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: accentColor]

        /* todo: CAUTION!
            it changes button's text foreground color only without chevron
            and it's better to change tintColor for all the appearance
        */
        //appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: accentColor]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        /* todo: ATTENTION!
            it sets tint color for even custom buttons and chevrons
        */
        UINavigationBar.appearance().tintColor = accentColor
    }
}
