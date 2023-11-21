//
//  Data.swift
//  AppleDevices
//
//  Created by AUGUSTIN BRIOLON on 20/11/2023.
//

import Foundation

struct DataSchema: Identifiable {
    let id: UUID = UUID()
    var deviceName: String
    var purchaseDate: Date
    var serialNumber: Double?
    var selectedDevice: DeviceType
    var selectedModel: String
    var imageURL: String
}

extension DataSchema {
    static let DataPreview: [DataSchema] = [
        DataSchema(deviceName: "Mon iPhone 12", purchaseDate: Date(), serialNumber: 123456, selectedDevice: .iPhone, selectedModel: "12", imageURL: "https://m.media-amazon.com/images/I/51z+NjVRdEL._AC_UF1000,1000_QL80_.jpg"),
        DataSchema(deviceName: "Mon MacBook Pro", purchaseDate: Date(), serialNumber: 213456, selectedDevice: .MacBook, selectedModel: "Pro", imageURL: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/refurb-mbp16touch-space-gallery-2019_GEO_EMEA_LANG_FR?wid=1250&hei=1200&fmt=jpeg&qlt=95&.v=1582233089617"),
        DataSchema(deviceName: "Mes Airpod Pro", purchaseDate: Date(), serialNumber: 321456, selectedDevice: .Airpod, selectedModel: "Pro", imageURL: "https://m.media-amazon.com/images/I/71zny7BTRlL._AC_UF1000,1000_QL80_.jpg"),
        DataSchema(deviceName: "Mon HomePod Mini", purchaseDate: Date(), serialNumber: 432156, selectedDevice: .HomePod, selectedModel: "Mini", imageURL: "https://cdn.lesnumeriques.com/optim/product/60/60459/43f9d408-homepod-mini__450_400.jpeg"),
        DataSchema(deviceName: "Ma Watch Ultra", purchaseDate: Date(), serialNumber: 543216, selectedDevice: .Watch, selectedModel: "Ultra", imageURL: "https://media.ldlc.com/r1600/ld/products/00/06/06/47/LD0006064790.jpg"),
    ]
}
