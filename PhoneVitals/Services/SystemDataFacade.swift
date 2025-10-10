//
//  SystemDataFacade.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 10/10/25.
//

import Foundation
import UIKit

struct SystemDataFacade {

    func getAllSystemData() async -> SystemDataProfileModel {

        let thermalState = await getThermalState()
        let batteryLevel = await getBatteryLevel()
        let batteryState = await getBatteryState()
        let storageCapacity = await getStorageCapacity()
        let storageUsed = await getStorageUsed()
        let storageAvailable = await getStorageAvailable()
        let cpuUsage = await getCpuUsage()
        let memoryUsage = await getMemoryUsage()
        let memoryCapacity = await getMemoryCapacity()
        let memoryFree = await getMemoryFree()

        return SystemDataProfileModel(
            id: nil,
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
            timestamp: Date.now
        )
    }

    @MainActor
    private func getThermalState() -> String {
        let thermalState = ProcessInfo.processInfo.thermalState.rawValue
        return ThermalStateGrade.mapFromOriginThermalState(state: thermalState)
    }

    @MainActor
    private func getBatteryLevel() -> Double {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        return Double(batteryLevel)
    }

    @MainActor
    private func getBatteryState() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryState = UIDevice.current.batteryState
        return batteryState.rawValue
    }

    @MainActor
    private func getStorageCapacity() -> Int {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let capacity = attributes[FileAttributeKey.systemSize] as! Int
        return capacity
    }

    @MainActor
    private func getStorageUsed() -> Int {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let capacity = attributes[FileAttributeKey.systemSize] as! Int
        let freeSize = attributes[FileAttributeKey.systemFreeSize] as! Int
        let usage = capacity - freeSize
        return usage
    }

    @MainActor
    private func getStorageAvailable() -> Int {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let freeSize = attributes[FileAttributeKey.systemFreeSize] as! Int
        return freeSize
    }

    @MainActor
    private func getCpuUsage() -> Double {
        return 0.0
    }

    @MainActor
    private func getMemoryUsage() -> Double {
        return 0.0
    }

    @MainActor
    private func getMemoryCapacity() -> Int {
        return 128
    }

    @MainActor
    private func getMemoryFree() -> Int {
        return 53
    }
}
