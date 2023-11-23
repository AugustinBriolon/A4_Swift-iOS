//
//  DeviceStore.swift
//  AppleDevices
//
//  Created by AUGUSTIN BRIOLON on 23/11/2023.
//

import Foundation
import SwiftUI

@MainActor
class DeviceStore: ObservableObject {
    @Published var devices: [DataSchema] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }
    
    func load() async throws {
        let fileURL = try Self.fileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            devices = try JSONDecoder().decode([DataSchema].self, from: data)
        } catch {
            // Gérez les erreurs ici (par exemple, si la lecture des données échoue)
            print("Error loading data: \(error)")
        }
    }

    func save(devices: [DataSchema]) async throws {
        let fileURL = try Self.fileURL()
        do {
            let data = try JSONEncoder().encode(devices)
            try await data.write(to: fileURL)
        } catch {
            // Gérez les erreurs ici (par exemple, si l'écriture des données échoue)
            print("Error saving data: \(error)")
        }
    }

}
