import SwiftUI
import Combine

private let deviceNameKey = "DeviceName"
private let serialNumberKey = "SerialNumber"
private let purchaseDateKey = "PurchaseDate"
private let purchasePrice = "PurchasePrice"
private let selectedDeviceKey = "SelectedDevice"
private let selectedModelKey = "SelectedModel"
private let imageURLKey = "ImageURL"

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
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var deviceName: String
    @State private var serialNumber: String
    @State private var purchaseDate: Date
    @State private var purchasePrice: String
    @State private var selectedDevice: DeviceType
    @State private var selectedModel: String
    @State private var imageURL: String
    @State private var image: Image?
    @State private var showAlert = false
    @State private var errorAlert: Alert?

    init(devices: Binding<[DataSchema]>, existingDevice: DataSchema? = nil) {
        _devices = devices
        self.existingDevice = existingDevice
        if let existingDevice = existingDevice {
            _deviceName = State(initialValue: existingDevice.deviceName)
            _serialNumber = State(initialValue: existingDevice.serialNumber)
            _purchaseDate = State(initialValue: existingDevice.purchaseDate)
            _purchasePrice = State(initialValue: existingDevice.purchasePrice)
            _selectedDevice = State(initialValue: existingDevice.selectedDevice)
            _selectedModel = State(initialValue: existingDevice.selectedModel)
            _imageURL = State(initialValue: existingDevice.imageURL)
        } else {
            _deviceName = State(initialValue: "")
            _serialNumber = State(initialValue: "")
            _purchaseDate = State(initialValue: Date())
            _purchasePrice = State(initialValue: "")
            _selectedDevice = State(initialValue: .iPhone)
            _selectedModel = State(initialValue: "")
            _imageURL = State(initialValue: "")
        }
    }

    private func deviceInfoSection() -> some View {
        Section {
            TextField("Nom de l'élément", text: $deviceName)
            TextField("Numéro de série", text: $serialNumber)
                .keyboardType(.numberPad)
        }
    }
    
    private func devicePurchaseSection() -> some View {
        Section {
            DatePicker("Date d'achat", selection: $purchaseDate, displayedComponents: .date)
            TextField("Numéro de série", text: $purchasePrice)
                .keyboardType(.numberPad)
        }
    }

    private func deviceTypeSection() -> some View {
        Section {
            Picker("Type d'appareil", selection: $selectedDevice) {
                ForEach(DeviceType.allCases, id: \.self) { device in
                    Text(device.rawValue)
                }
            }
            deviceModelPicker()
        }
    }

    private func deviceModelPicker() -> some View {
        switch selectedDevice {
        case .iPhone:
            return AnyView(Picker("Modèle d'iPhone", selection: $selectedModel) {
                ForEach(["iPhone 12", "iPhone 13", "iPhone 14", "iPhone 15"], id: \.self) {
                    Text($0)
                }
            })
        case .MacBook:
            return AnyView(Picker("Modèle de MacBook", selection: $selectedModel) {
                Text("MacBook Air")
                Text("MacBook Pro")
            })
        case .Watch:
            return AnyView(Picker("Modèle de Watch", selection: $selectedModel) {
                Text("Watch SE")
                Text("Watch Ultra")
            })
        case .HomePod:
            return AnyView(Picker("Modèle d'HomePod", selection: $selectedModel) {
                Text("HomePod")
                Text("HomePod Mini")
            })
        case .Airpod:
            return AnyView(Picker("Modèle d'Airpod", selection: $selectedModel) {
                Text("Airpod Pro")
                Text("Airpod Max")
            })
        }
    }

    private func imageSection() -> some View {
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
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
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
        if let url = URL(string: imageURL) {
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
        if let existingDeviceIndex = devices.firstIndex(where: { $0.id == existingDevice?.id }) {
            devices[existingDeviceIndex].deviceName = deviceName
            devices[existingDeviceIndex].serialNumber = serialNumber
            devices[existingDeviceIndex].purchaseDate = purchaseDate
            devices[existingDeviceIndex].selectedDevice = selectedDevice
            devices[existingDeviceIndex].selectedModel = selectedModel
            devices[existingDeviceIndex].imageURL = imageURL
        } else {
            // Ajout d'un nouvel élément
            let newDevice = DataSchema(
                deviceName: deviceName,
                purchaseDate: purchaseDate,
                purchasePrice: purchasePrice,
                serialNumber: serialNumber,
                selectedDevice: selectedDevice,
                selectedModel: selectedModel,
                imageURL: imageURL
            )

            // Ajoute le nouvel élément à la liste
            devices.append(newDevice)
        }
        presentationMode.wrappedValue.dismiss()
    }


    private func resetFields() {
        // Remets à zéro les champs après l'ajout ou la modification
        deviceName = ""
        serialNumber = ""
        purchaseDate = Date()
        purchasePrice = ""
        selectedDevice = .iPhone
        selectedModel = ""
        imageURL = ""
    }
}
