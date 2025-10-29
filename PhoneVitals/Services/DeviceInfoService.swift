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

    private let deviceName = UIDevice.current.name
    private let modelName = UIDevice.modelName
    private let modelIdentifier = UIDevice.modelIdentifier
    private var deviceSystemVersion = {
        let sysVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let splitIndex = sysVersion.firstIndex(of: "(")
        if let splitIndex = splitIndex {
            return String(sysVersion[..<splitIndex]).trimmingCharacters(in: .whitespaces)
        }
        return sysVersion
    }

    //MARK: - INITIALIZER
    init() {
        self.deviceInfo = DeviceInfo(
            deviceName: deviceName,
            modelName: modelName,
            modelIdentifier: modelIdentifier,
            deviceSystemVersion: deviceSystemVersion()
        )
    }

    //MARK: - FUNCTIONS
    func getDeviceInfo() -> DeviceInfo {
        return deviceInfo
    }
}
