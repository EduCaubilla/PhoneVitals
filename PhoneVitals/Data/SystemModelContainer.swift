//
//  SystemModelContainer.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 10/10/25.
//

import SwiftData
struct SystemModelContainer {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SystemDataProfileDTO.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
