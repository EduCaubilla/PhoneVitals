//
//  Item.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import SwiftData

@Model
final class SystemDataProfileDTO {
    @Attribute(.unique) var id: UUID?
    var thermalState: String

    var batteryLevel: Double
    var batteryState: Int

    var storageCapacity: Int
    var storageUsed: Int
    var storageAvailable: Int

    var cpuUsage: Double

    var memoryUsage: Double
    var memoryCapacity: Int
    var memoryFree: Int

    var timestamp: Date

    var overallHealth: String?

    init(
        id: UUID?,
        thermalState: String,
        batteryLevel: Double,
        batteryState: Int,
        storageCapacity: Int,
        storageUsed: Int,
        storageAvailable: Int,
        cpuUsage: Double,
        memoryUsage: Double,
        memoryCapacity: Int,
        memoryFree: Int,
        timestamp: Date
    ) {
        self.id = id ?? UUID()
        self.thermalState = thermalState
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
        self.storageCapacity = storageCapacity
        self.storageUsed = storageUsed
        self.storageAvailable = storageAvailable
        self.cpuUsage = cpuUsage
        self.memoryUsage = memoryUsage
        self.memoryCapacity = memoryCapacity
        self.memoryFree = memoryFree
        self.timestamp = timestamp
    }

    func mapToModel() -> SystemDataProfileModel {
        return SystemDataProfileModel(
            id: id,
            thermalState: thermalState,
            batteryLevel: batteryLevel,
            batteryState: batteryState,
            storageCapacity: storageCapacity,
            storageUsed: storageUsed,
            storageAvailable: storageAvailable,
            cpuUsage: cpuUsage,
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            timestamp: timestamp
            )
    }
}
