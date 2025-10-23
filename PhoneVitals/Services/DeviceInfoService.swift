//
//  DeviceInfoService.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 13/10/25.
//

import Foundation
import SwiftUI

class DeviceInfoService {
    //MARK: - PROPERTIES
    private let deviceInfo: DeviceInfo

    private let modelName = UIDevice.modelName
    private let modelIdentifier = UIDevice.modelIdentifier
    private let deviceSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString

    //MARK: - INITIALIZER
    init() {
        self.deviceInfo = DeviceInfo(
            modelName: modelName,
            modelIdentifier: modelIdentifier,
            deviceSystemVersion: deviceSystemVersion
        )
    }

    //MARK: - FUNCTIONS
    func getDeviceInfo() -> DeviceInfo {
        return deviceInfo
    }
}
