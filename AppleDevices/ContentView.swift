import SwiftUI

struct ContentView: View {
    @State private var devices: [DataSchema] = DataSchema.DataPreview
    @State private var showDeviceScreen = false
    @State private var selectedDevice: DataSchema? = nil
    @State private var usdValue: Double?
    
    var totalCost: Double {
        devices.compactMap { Double($0.purchasePrice) }.reduce(0, +)
    }
    
    var converttCost: Double {
        totalCost * usdValue!
    }
    
    struct APIResponse: Decodable {
        let conversionRates: [String: Double]
        
        private enum CodingKeys: String, CodingKey {
            case conversionRates = "conversion_rates"
        }
    }
    
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
                Section {
                    HStack {
                        Text("Coût total :")
                            .font(.headline)
                        Spacer()
                        Text("\(totalCost) €")
                            .font(.headline)
                    }
                }
                Section {
                    if usdValue != nil {
                        Text("Taux de change USD: \(converttCost)")
                    } else {
                        Text("Appuie sur le bouton pour convertir vos appareils en valeur USD.")
                    }
                    
                    if usdValue == nil {
                        Button(action: {
                            fetchData()
                        }) {
                            Text("Faire l'appel API")
                                .foregroundColor(.blue)
                        }
                    }
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
    
    func fetchData() {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/4690460c91a9a0ad097c4aa3/latest/eur") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur: \(error)")
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    if let usdRate = result.conversionRates["USD"] {
                        DispatchQueue.main.async {
                            self.usdValue = usdRate
                        }
                    }
                } catch {
                    print("Erreur de décodage: \(error)")
                }
            }
        }.resume()
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
