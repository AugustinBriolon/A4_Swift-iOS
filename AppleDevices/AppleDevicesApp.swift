//
//  AppleDevicesApp.swift
//  AppleDevices
//
//  Created by AUGUSTIN BRIOLON on 20/11/2023.
//

import SwiftUI

@main
struct AppleDevicesApp: App {
    @StateObject private var deviceStore = DeviceStore()

    var body: some Scene {
        WindowGroup {
            ContentView(saveAction: {
                Task {
                    do {
                        try await deviceStore.save(devices: deviceStore.devices)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            })
            .onAppear {
                Task {
                    do {
                        try await deviceStore.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
