//
//  StorageInfoService.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 15/10/25.
//

import Foundation

class StorageInfoService {
    //MARK: - PROPERTIES
    private var storageInfo: StorageInfo?

    //MARK: - INITIALIZER
    init() {
        self.storageInfo = setStorageInfo()
    }

    //MARK: - FUNCTIONS
    private func setStorageInfo() -> StorageInfo? {
        do {
            guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                  let totalCapacity = systemAttributes[.systemSize] as? Int64 else { return nil }

            let url = URL(fileURLWithPath: NSHomeDirectory())
            let values = try url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])

            guard let availableCapacity = values.volumeAvailableCapacityForImportantUsage else { return nil }

            let usedCapacity = totalCapacity - availableCapacity

            return StorageInfo(
                totalCapacity: Tools.bytesToGigaBytes(totalCapacity),
                availableCapacity: Tools.bytesToGigaBytes(availableCapacity),
                usedCapacity: Tools.bytesToGigaBytes(usedCapacity)
            )
        } catch {
            print("Error getting storage info \(error)")
            return nil
        }
    }

    func getStorageInfo() -> StorageInfo? {
        return self.storageInfo
    }
}
