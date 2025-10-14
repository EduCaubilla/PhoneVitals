//
//  SystemDataProfileModel.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 3/10/25.
//

import Foundation
import SwiftData
import UIKit

public struct SystemDataProfileModel: Codable, Equatable {
    var id: UUID?
    var thermalState: String

    var batteryLevel: Double
    var batteryState: String

    var storageCapacity: Double
    var storageUsed: Double
    var storageAvailable: Double

    var memoryUsage: Double
    var memoryCapacity: Double
    var memoryFree: Double

    var cpuUsage: Double

    var timestamp: Date

    var overallHealth: String?

    var memoryLevel: Double {
        guard memoryCapacity > 0 else { return 0 }
        return Double(memoryUsage) / Double(memoryCapacity) * 100
    }

    init(
        id: UUID?,
        thermalState: String,
        batteryLevel: Double,
        batteryState: String,
        storageCapacity: Double,
        storageUsed: Double,
        storageAvailable: Double,
        memoryUsage: Double,
        memoryCapacity: Double,
        memoryFree: Double,
        cpuUsage: Double,
        timestamp: Date
    ) {
        self.id = id
        self.thermalState = thermalState
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

    func mapToDTO() -> SystemDataProfileDTO {
        return SystemDataProfileDTO(
            id: id,
            thermalState: ThermalStateGrade(rawValue: thermalState) ?? .fair,
            batteryLevel: batteryLevel,
            batteryState: UIDevice.BatteryState.mapFromStringToInt(batteryState),
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
