import SwiftUI

enum DeviceType: String, CaseIterable {
    case iPhone = "📱 iPhone"
    case MacBook = "💻 MacBook"
    case Watch = "⌚️ Watch"
    case HomePod = "🔊 HomePod"
    case Airpod = "🎧 AirPod"
}

struct NewDeviceScreen: View {
    @Binding var devices: [DataSchema]
    var existingDevice: DataSchema?

    @State private var deviceName: String
    @State private var purchaseDate: Date
    @State private var selectedDevice: DeviceType
    @State private var selectedModel: String
    @State private var imageURL: String
    @State private var image: Image?
    @State private var errorAlert: Alert?

    init(devices: Binding<[DataSchema]>, existingDevice: DataSchema? = nil) {
        _devices = devices
        self.existingDevice = existingDevice

        // Initialisation des états en fonction de la présence ou non d'un élément existant
        if let existingDevice = existingDevice {
            _deviceName = State(initialValue: existingDevice.deviceName)
            _purchaseDate = State(initialValue: existingDevice.purchaseDate)
            _selectedDevice = State(initialValue: DeviceType(rawValue: existingDevice.selectedDevice) ?? .iPhone)
            _selectedModel = State(initialValue: existingDevice.selectedModel)
            _imageURL = State(initialValue: existingDevice.imageURL)
        } else {
            _deviceName = State(initialValue: "")
            _purchaseDate = State(initialValue: Date())
            _selectedDevice = State(initialValue: .iPhone)
            _selectedModel = State(initialValue: "")
            _imageURL = State(initialValue: "")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Nom de l'élément", text: $deviceName)
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
                    addNewDevice()
                }) {
                    Text("Ajouter 🚀")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                
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

    private func addNewDevice() {
        let newDevice = DataSchema(
            deviceName: deviceName,
            purchaseDate: purchaseDate,
            serialNumber: "", // Ajoute le numéro de série si nécessaire
            selectedDevice: selectedDevice.rawValue,
            selectedModel: selectedModel,
            imageURL: imageURL
        )

        // Ajoute le nouvel élément à la liste
        devices.append(newDevice)

        // Remets à zéro les champs après l'ajout
        deviceName = ""
        purchaseDate = Date()
        selectedDevice = .iPhone
        selectedModel = ""
        imageURL = ""
    }
}
