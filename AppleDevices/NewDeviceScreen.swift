import SwiftUI

struct DeviceInfo {
    var deviceName: String
    var serialNumber: String
    var purchaseDate: Date
    var purchasePrice: String
    var selectedDevice: DeviceType
    var selectedModel: String
    var imageURL: String
}

enum DeviceType: String, CaseIterable, Codable {
    case iPhone = "📱 iPhone"
    case MacBook = "💻 MacBook"
    case Watch = "⌚️ Watch"
    case HomePod = "🔊 HomePod"
    case Airpod = "🎧 AirPod"
}

struct NewDeviceScreen: View {
    @Binding var devices: [DataSchema]
    var existingDevice: DataSchema?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var deviceInfo: DeviceInfo
    @State private var image: Image?
    @State private var showAlert = false
    @State private var errorAlert: Alert?

    init(devices: Binding<[DataSchema]>, existingDevice: DataSchema? = nil) {
        _devices = devices
        self.existingDevice = existingDevice
        _deviceInfo = State(initialValue: existingDevice?.toDeviceInfo() ?? DeviceInfo.default)
    }

    private func deviceInfoSection() -> some View {
        Section {
            TextField("Nom de l'élément", text: $deviceInfo.deviceName)
            TextField("Numéro de série", text: $deviceInfo.serialNumber)
                .keyboardType(.numberPad)
        }
    }
    
    private func devicePurchaseSection() -> some View {
        Section {
            DatePicker("Date d'achat", selection: $deviceInfo.purchaseDate, displayedComponents: .date)
            TextField("Prix d'achat", text: $deviceInfo.purchasePrice)
                .keyboardType(.numberPad)
        }
    }

    private func deviceTypeSection() -> some View {
        Section {
            Picker("Type d'appareil", selection: $deviceInfo.selectedDevice) {
                ForEach(DeviceType.allCases, id: \.self) { device in
                    Text(device.rawValue)
                }
            }
            deviceModelPicker()
        }
    }

    private func deviceModelPicker() -> some View {
        Section {
            switch deviceInfo.selectedDevice {
            case .iPhone:
                return AnyView(Picker("Modèle d'iPhone", selection: $deviceInfo.selectedModel) {
                    ForEach(["iPhone 12", "iPhone 13", "iPhone 14", "iPhone 15"], id: \.self) {
                        Text($0)
                    }
                })
            case .MacBook:
                return AnyView(Picker("Modèle de MacBook", selection: $deviceInfo.selectedModel) {
                    Text("MacBook Air")
                    Text("MacBook Pro")
                })
            case .Watch:
                return AnyView(Picker("Modèle de Watch", selection: $deviceInfo.selectedModel) {
                    Text("Watch SE")
                    Text("Watch Ultra")
                })
            case .HomePod:
                return AnyView(Picker("Modèle d'HomePod", selection: $deviceInfo.selectedModel) {
                    Text("HomePod")
                    Text("HomePod Mini")
                })
            case .Airpod:
                return AnyView(Picker("Modèle d'Airpod", selection: $deviceInfo.selectedModel) {
                    Text("Airpod Pro")
                    Text("Airpod Max")
                })
            }
        }
    }


    private func imageSection() -> some View {
        Section {
            TextField("URL de l'image", text: $deviceInfo.imageURL)
            Button(action: {
                loadImage()
            }) {
                Text("Charger l'image")
                    .foregroundColor(.blue)
            }

            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    deviceInfoSection()
                    devicePurchaseSection()
                    deviceTypeSection()
                    imageSection()
                }

                Button(action: {
                    addOrUpdateDevice()
                }) {
                    Text(existingDevice == nil ? "Ajouter 🚀" : "Modifier 🔄")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .navigationBarTitle("Création d'élément")
            .alert(isPresented: $showAlert, content: {
                errorAlert ?? Alert(title: Text("Erreur"), message: Text("Erreur inattendue"), dismissButton: .default(Text("OK")))
            })
        }
    }

    private func loadImage() {
        if let url = URL(string: deviceInfo.imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let uiImage = UIImage(data: data) {
                        image = Image(uiImage: uiImage)
                        showAlert = false
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
        showAlert = true
    }

    private func addOrUpdateDevice() {
        let dataSchema = deviceInfo.toDataSchema()

        if let existingDeviceIndex = devices.firstIndex(where: { $0.id == existingDevice?.id }) {
            devices[existingDeviceIndex] = dataSchema
        } else {
            devices.append(dataSchema)
        }

        resetFields()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func resetFields() {
        deviceInfo = DeviceInfo.default
        image = nil
    }
}

private extension DeviceInfo {
    func toDataSchema() -> DataSchema {
        return DataSchema(
            deviceName: deviceName,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            serialNumber: serialNumber,
            selectedDevice: selectedDevice,
            selectedModel: selectedModel,
            imageURL: imageURL
        )
    }
    
    static var `default`: DeviceInfo {
        return DeviceInfo(
            deviceName: "",
            serialNumber: "",
            purchaseDate: Date(),
            purchasePrice: "",
            selectedDevice: .iPhone,
            selectedModel: "",
            imageURL: ""
        )
    }
}

private extension DataSchema {
    func toDeviceInfo() -> DeviceInfo {
        return DeviceInfo(
            deviceName: deviceName,
            serialNumber: serialNumber,
            purchaseDate: purchaseDate,
            purchasePrice: purchasePrice,
            selectedDevice: selectedDevice,
            selectedModel: selectedModel,
            imageURL: imageURL
        )
    }
}
