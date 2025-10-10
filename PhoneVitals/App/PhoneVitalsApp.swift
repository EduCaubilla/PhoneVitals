//
//  PhoneVitalsApp.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

@main
struct PhoneVitalsApp: App {
    var body: some Scene {
        WindowGroup {
            MainSystemDataView()
        }
        .modelContainer(SystemModelContainer.shared)
    }
}
