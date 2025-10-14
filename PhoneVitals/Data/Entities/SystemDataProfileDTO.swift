//
//  Item.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class SystemDataProfileDTO {
    @Attribute(.unique) var id: UUID?
    var thermalState: String

    var batteryLevel: Double
    var batteryState: Int

    var storageCapacity: Double
    var storageUsed: Double
    var storageAvailable: Double

    var memoryUsage: Double
    var memoryCapacity: Double
    var memoryFree: Double

    var cpuUsage: Double

    var timestamp: Date

    var overallHealth: String?

    init(
        id: UUID?,
        thermalState: ThermalStateGrade,
        batteryLevel: Double,
        batteryState: Int,
        storageCapacity: Double,
        storageUsed: Double,
        storageAvailable: Double,
        memoryUsage: Double,
        memoryCapacity: Double,
        memoryFree: Double,
        cpuUsage: Double,
        timestamp: Date
    ) {
        self.id = id ?? UUID()
        self.thermalState = thermalState.rawValue
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
        self.storageCapacity = storageCapacity
        self.storageUsed = storageUsed
        self.storageAvailable = storageAvailable
        self.memoryUsage = memoryUsage
        self.memoryCapacity = memoryCapacity
        self.memoryFree = memoryFree
        self.cpuUsage = cpuUsage
        self.timestamp = timestamp
    }

    func mapToModel() -> SystemDataProfileModel {
        return SystemDataProfileModel(
            id: id,
            thermalState: thermalState,
            batteryLevel: batteryLevel,
            batteryState: UIDevice.BatteryState(rawValue: batteryState)!.displayName,
            storageCapacity: storageCapacity,
            storageUsed: storageUsed,
            storageAvailable: storageAvailable,
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            cpuUsage: cpuUsage,
            timestamp: timestamp
            )
    }
}
