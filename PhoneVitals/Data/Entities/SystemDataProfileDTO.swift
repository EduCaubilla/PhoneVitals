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
    var batteryState: String

    var storageCapacity: Double
    var storageUsed: Double
    var storageAvailable: Double

    var memoryUsage: Double
    var memoryCapacity: Double
    var memoryFree: Double

    var cpuUsageUser: Double
    var cpuUsageSystem: Double
    var cpuUsageInactive: Double

    var timestamp: Date

    var overallHealth: String?

    init(
        id: UUID?,
        thermalState: ThermalStateGrade,
        batteryLevel: Double,
        batteryState: String,
        storageCapacity: Double,
        storageUsed: Double,
        storageAvailable: Double,
        memoryUsage: Double,
        memoryCapacity: Double,
        memoryFree: Double,
        cpuUsageUser: Double,
        cpuUsageSystem: Double,
        cpuUsageInactive: Double,
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
        self.cpuUsageUser = cpuUsageUser
        self.cpuUsageSystem = cpuUsageSystem
        self.cpuUsageInactive = cpuUsageInactive
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
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            cpuUsageUser: cpuUsageUser,
            cpuUsageSystem: cpuUsageSystem,
            cpuUsageInactive: cpuUsageInactive,
            timestamp: timestamp
            )
    }
}
