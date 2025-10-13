//
//  DeviceInfoService.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 13/10/25.
//

import Foundation
import SwiftUI

class DeviceInfoService {
    private let deviceInfo: DeviceInfo

    private let model = UIDevice.current.model
    private let systemName = UIDevice.current.systemName
    private let systemVersion = UIDevice.current.systemVersion
    private let deviceSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString

    init() {
        self.deviceInfo = DeviceInfo(
            model: model,
            systemName: systemName,
            systemVersion: systemVersion,
            deviceSystemVersion: deviceSystemVersion
        )
    }

    public func getDeviceInfo() -> DeviceInfo {
        return deviceInfo
    }
}

struct DeviceInfo {
    let model: String
    let systemName: String
    let systemVersion: String
    let deviceSystemVersion: String
}
