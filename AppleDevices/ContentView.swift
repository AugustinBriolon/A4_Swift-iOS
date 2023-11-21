import SwiftUI

struct ContentView: View {
    @State private var devices: [DataSchema] = DataSchema.DataPreview
    @State private var selectedDevice: DataSchema? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(devices) { device in
                    NavigationLink(destination: NewDeviceScreen(devices: $devices, existingDevice: device)) {
                        HStack {
                            // Image à gauche
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(device.deviceName)
                                    .font(.headline)
                                Text(device.purchaseDate, style: .date)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteDevice)
            }
            .navigationBarTitle("Liste des Éléments")
            .navigationBarItems(trailing: addButton)
            .navigationBarItems(trailing: EditButton())

            NavigationLink(destination: NewDeviceScreen(devices: $devices)) {
                Text("Add new")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
            }
        }
    }

    private var addButton: some View {
        NavigationLink(destination: NewDeviceScreen(devices: $devices)) {
            Image(systemName: "plus.circle")
        }
    }

    private func deleteDevice(at offsets: IndexSet) {
        devices.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
