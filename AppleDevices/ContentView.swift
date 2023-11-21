import SwiftUI

struct ContentView: View {
    @State private var devices: [DataSchema] = DataSchema.DataPreview
    @State private var showDeviceScreen = false
    @State private var selectedDevice: DataSchema? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(devices) { device in
                    DeviceRow(device: device)
                        .onTapGesture {
                            selectedDevice = device
                            showDeviceScreen.toggle()
                        }
                }
                .onDelete(perform: deleteDevice)
                .onMove { indexSet, index in
                    devices.move(fromOffsets: indexSet, toOffset: index)
                }
            }
            .navigationBarTitle("Liste des Éléments")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    selectedDevice = nil
                    showDeviceScreen.toggle()
                }) {
                    Image(systemName: "plus.circle")
                }
            )
            .sheet(isPresented: $showDeviceScreen) {
                NewDeviceScreen(devices: $devices, existingDevice: selectedDevice)
            }
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

struct DeviceRow: View {
    let device: DataSchema

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: device.imageURL)) { phase in
               switch phase {
               case .empty:
                   Image(systemName: "photo")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
               case .success(let image):
                   image
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
               case .failure:
                   Image(systemName: "photo")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
               @unknown default:
                   // Gérer les cas inconnus
                   Image(systemName: "photo")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 50, height: 50)
                       .clipShape(Circle())
               }
           }

            VStack(alignment: .leading) {
                Text(device.deviceName)
                    .font(.headline)
                Text(device.purchaseDate, style: .date)
                    .font(.subheadline)
            }
        }
    }
}
