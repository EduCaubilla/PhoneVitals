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
    private func setStorageInfo() -> StorageInfo {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())

        let totalCapacity = attributes[FileAttributeKey.systemSize] as! Double
        let availableCapacity = attributes[FileAttributeKey.systemFreeSize] as! Double
        let usedCapacity = totalCapacity - availableCapacity

        return StorageInfo(
            totalCapacity: Utils.bytesToGigaBytes(totalCapacity),
            usedCapacity: Utils.bytesToGigaBytes(usedCapacity),
            availableCapacity: Utils.bytesToGigaBytes(availableCapacity)
        )
    }

    func getStorageInfo() -> StorageInfo? {
        return self.storageInfo
    }
}
