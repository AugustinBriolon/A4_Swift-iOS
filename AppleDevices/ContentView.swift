import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = [
        Item(name: "iPhone 12", purchaseDate: Date(), imageURL: "https://example.com/iphone12.jpg"),
        Item(name: "MacBook Air", purchaseDate: Date(), imageURL: "https://example.com/macbookair.jpg"),
        // Ajoute d'autres éléments selon tes besoins
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack {
                        // Image à gauche
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        // Nom de l'item et date d'achat
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.purchaseDate, style: .date)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .navigationBarTitle("Liste des Éléments")
            .navigationBarItems(trailing: EditButton())
            
            NavigationLink(destination: NewDeviceScreen(items: $items), label: {
                Text("Add new")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            })
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var purchaseDate: Date
    var imageURL: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
