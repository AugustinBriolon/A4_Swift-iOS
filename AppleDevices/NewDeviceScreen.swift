import SwiftUI

enum DeviceType: String, CaseIterable {
    case iPhone = "📱 iPhone"
    case MacBook = "💻 MacBook"
    case Watch = "⌚️ Watch"
    case HomePod = "🔊 HomePod"
    case Airpod = "🎧 AirPod"
}

class test: Identifiable {
    var id = UUID()
    var name: String
    var purchaseDate: Date
    var imageURL: String

    init(name: String, purchaseDate: Date, imageURL: String) {
        self.name = name
        self.purchaseDate = purchaseDate
        self.imageURL = imageURL
    }
}

struct NewDeviceScreen: View {
    @Binding var items: [Item]
    
    @State private var itemName = ""
    @State private var purchaseDate = Date()
    @State private var serialNumber = ""
    @State private var selectedDevice: DeviceType = .iPhone
    @State private var selectedModel = ""
    @State private var imageURL = ""
    @State private var image: Image? = nil
    @State private var errorAlert: Alert?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Nom de l'élément", text: $itemName)
                        TextField("Numéro de série", text: $serialNumber)
                    }

                    Section {
                        DatePicker("Date d'achat", selection: $purchaseDate, displayedComponents: .date)
                    }

                    Section {
                        Picker("Type d'appareil", selection: $selectedDevice) {
                            ForEach(DeviceType.allCases, id: \.self) { device in
                                Text(device.rawValue)
                            }
                        }

                        if selectedDevice == .iPhone {
                            Picker("Modèle d'iPhone", selection: $selectedModel) {
                                Text("iPhone 12")
                                Text("iPhone 13")
                                Text("iPhone 14")
                                Text("iPhone 15")
                            }
                        } else if selectedDevice == .MacBook {
                            Picker("Modèle de MacBook", selection: $selectedModel) {
                                Text("MacBook Air")
                                Text("MacBook Pro")
                            }
                        } else if selectedDevice == .Watch {
                            Picker("Modèle de Watch", selection: $selectedModel) {
                                Text("Watch SE")
                                Text("Watch Ultra")
                            }
                        } else if selectedDevice == .HomePod {
                            Picker("Modèle d'HomePod", selection: $selectedModel) {
                                Text("HomePod")
                                Text("HomePod Mini")
                            }
                        } else if selectedDevice == .Airpod {
                            Picker("Modèle d'Airpod", selection: $selectedModel) {
                                Text("Airpod Pro")
                                Text("Airpod Max")
                            }
                        }
                    }

                    Section {
                        TextField("URL de l'image", text: $imageURL)
                        Button(action: {
                            loadImage()
                        }) {
                            Text("Charger l'image")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        // Affichage de l'image
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .padding()
                        }

                    }
                }

                Button(action: {
                    // Action à ajouter plus tard
                }) {
                    Text("Ajouter 🚀")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                
                Spacer()
            }
            .navigationBarTitle("Création d'élément")
        }
    }

    private func loadImage() {
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        image = Image(uiImage: uiImage)
                        errorAlert = nil
                    } else {
                        showErrorAlert(message: "Erreur lors de la conversion de l'image.")
                    }
                } else if let error = error {
                    showErrorAlert(message: "Erreur de chargement de l'image : \(error.localizedDescription)")
                }
            }.resume()
        } else {
            showErrorAlert(message: "URL invalide.")
        }
    }

    private func showErrorAlert(message: String) {
        errorAlert = Alert(title: Text("Erreur"), message: Text(message), dismissButton: .default(Text("OK")))
    }
}
