//
//  Data.swift
//  AppleDevices
//
//  Created by AUGUSTIN BRIOLON on 20/11/2023.
//

import Foundation

struct DataShema: Identifiable {
    let id: UUID = UUID()
    let deviceName: String
    let purchaseDate: Date = Date()
    let serialNumber: String
    let selectedDevice: String
    let selectedModel: String
    let imageURL: String
}

