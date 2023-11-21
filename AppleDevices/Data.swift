//
//  Data.swift
//  AppleDevices
//
//  Created by AUGUSTIN BRIOLON on 20/11/2023.
//

import Foundation

struct DataSchema: Identifiable {
    let id: UUID = UUID()
    let deviceName: String
    let purchaseDate: Date
    let serialNumber: String
    let selectedDevice: String
    let selectedModel: String
    let imageURL: String
}

extension DataSchema {
    static let DataPreview: [DataSchema] = [
        DataSchema(deviceName: "iPhone 12", purchaseDate: Date(), serialNumber: "123456", selectedDevice: "iPhone", selectedModel: "12", imageURL: "https://m.media-amazon.com/images/I/51z+NjVRdEL._AC_UF1000,1000_QL80_.jpg"),
    ]
}
