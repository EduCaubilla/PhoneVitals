//
//  MockEntitiesData.swift
//  PhoneVitalsTests
//
//  Created by Edu Caubilla on 23/10/25.
//

import SwiftUI
@testable import PhoneVitals

// MARK: - Test Data Builders
extension MemoryInfo {
    static func mock(
        totalPhysical: Double = 8000,
        usedPhysical: Double = 5000,
        activeMemory: Double = 3000,
        wiredMemory: Double = 2000
    ) -> MemoryInfo {
        return MemoryInfo(
            totalPhysical: totalPhysical,
            usedPhysical: usedPhysical,
            activeMemory: activeMemory,
            wiredMemory: wiredMemory
        )
    }
}

extension CPUInfo {
    static func mock(
        totalProcessors: Int = 4,
        processorsUsed: Int = 2,
        systemCpu: Double = 23.0,
        userCpu: Double = 23.0,
        idleCpu: Double = 59.5,
        niceCpu: Double = 11.0) -> CPUInfo {
            return CPUInfo (
                totalProcessors: totalProcessors,
                processorsUsed: processorsUsed,
                systemCpu: systemCpu,
                userCpu: userCpu,
                idleCpu: idleCpu,
                niceCpu: niceCpu
            )
        }
}

extension StorageInfo {
    static func mock(
        totalCapacity: Double = 256000,
        availableCapacity: Double = 128000,
        usedCapacity: Double = 128000) -> StorageInfo {
        return StorageInfo(
            totalCapacity: totalCapacity,
            availableCapacity: availableCapacity,
            usedCapacity: usedCapacity
        )
    }
}

extension SystemDataProfileModel {
    static func mock(
        thermalState: String = "Nominal",
        batteryLevel: Double = 80.0,
        batteryState: String = "Charging",
        batteryLowPowerMode: Bool = false,
        storageCapacity: Double = 256000,
        storageUsed: Double = 128000,
        storageAvailable: Double = 128000,
        memoryUsage: Double = 5000,
        memoryCapacity: Double = 8000,
        memoryFree: Double = 3000,
        cpuUsageUser: Double = 25.5,
        cpuUsageSystem: Double = 15.0,
        cpuUsageInactive: Double = 59.5) -> SystemDataProfileModel {
        return SystemDataProfileModel(
            id: UUID(),
            thermalState: thermalState,
            batteryLevel: batteryLevel,
            batteryState: batteryState,
            batteryLowPowerMode: batteryLowPowerMode,
            storageCapacity: storageCapacity,
            storageUsed: storageUsed,
            storageAvailable: storageAvailable,
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            cpuUsageUser: cpuUsageUser,
            cpuUsageSystem: cpuUsageSystem,
            cpuUsageInactive: cpuUsageInactive,
            timestamp: Date()
        )
    }
}

extension DeviceInfo {
    static func mock() -> DeviceInfo {
        return DeviceInfo(
            deviceName: "My iPhone",
            modelName: "iPhone Test",
            modelIdentifier: "iPhone14,8",
            deviceSystemVersion: "iOSTestSystemVersion")
    }
}

extension OverviewData {
    static func mock(
        overallHealthScore: Double = 0,
        overallHealthLabel: String = "",
        overallHealthColor: Color = .white,

        thermalScore: Double = 75.0,
        batteryScore: Double = 80.0,
        storageScore: Double = 50.0,
        memoryScore: Double = 60.0,
        cpuScore: Double = 70.0) -> OverviewData {
        return OverviewData(
            overallHealthScore: overallHealthScore,
            overallHealthLabel: overallHealthLabel,
            overallHealthColor: overallHealthColor,
            thermalScore: thermalScore,
            batteryScore: batteryScore,
            storageScore: storageScore,
            memoryScore: memoryScore,
            cpuScore: cpuScore
        )
    }
}
