//
//  SystemDataStoreProtocol.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 3/10/25.
//

import Foundation
import SwiftData

protocol SystemDataStoreProtocol {
    func fetchAll() throws -> [SystemDataProfileModel]
    func save(_ profile: SystemDataProfileModel) throws -> Bool
    func delete(_ profile: SystemDataProfileModel) throws -> Bool
}
