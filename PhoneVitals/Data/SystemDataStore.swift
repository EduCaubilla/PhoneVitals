//
//  SystemDataStore.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 3/10/25.
//

import Foundation
import SwiftData

public final class SystemDataStore : SystemDataStoreProtocol {
    //MARK: - PROPERTIES
    private let modelContext: ModelContext

    //MARK: - INITIALIZER
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    //MARK: - FUNCTIONS
    func fetchAll() throws -> [SystemDataProfileModel] {
        let request = FetchDescriptor<SystemDataProfileDTO>(sortBy: [SortDescriptor(\.timestamp)])
        let results = try modelContext.fetch(request)
        return results.map{ $0.mapToModel() }
    }

    func save(_ profile: SystemDataProfileModel) throws -> Bool {
        let systemDataToSave = profile.mapToDTO()
        modelContext.insert(systemDataToSave)
        try modelContext.save()
        return true
    }

    func delete(_ profile: SystemDataProfileModel) throws -> Bool {
        let request = FetchDescriptor<SystemDataProfileDTO>(sortBy: [SortDescriptor(\.id)])
        let results = try modelContext.fetch(request)

        guard let resultToDelete = results.first else { return false }

        modelContext.delete(resultToDelete)
        try modelContext.save()
        return true
    }
}
