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
        self.id = id
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

    func mapToDTO() -> SystemDataProfileDTO {
        return SystemDataProfileDTO(
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
