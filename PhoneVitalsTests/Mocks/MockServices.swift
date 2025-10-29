//
//  MockServices.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 23/10/25.
//

import Foundation
import Combine
@testable import PhoneVitals

// MARK: - Mock Services

class MockMemoryInfoService: MemoryInfoService {
    var mockMemoryData: MemoryInfo?
    var shouldStartMonitoring = false
    var shouldStopMonitoring = false

    private let memorySubject = PassthroughSubject<MemoryInfo, Never>()

    override var memoryInfoPublisher: PassthroughSubject<MemoryInfo, Never> {
        get { mockMemorySubject }
        set { mockMemorySubject = newValue }
    }

    private var mockMemorySubject = PassthroughSubject<MemoryInfo, Never>()

    override func getMemoryData() -> MemoryInfo? {
        return mockMemoryData
    }

    override func startMonitoring(interval: TimeInterval = 1.0) {
        shouldStartMonitoring = true
    }

    override func stopMonitoring() {
        shouldStopMonitoring = true
    }

    func simulateMemoryUpdate(_ data: MemoryInfo) {
        mockMemorySubject.send(data)
    }
}

class MockCPUInfoService: CPUInfoService {
    var mockCPUData: CPUInfo?
    var shouldStartMonitoring = false
    var shouldStopMonitoring = false

    private let cpuSubject = PassthroughSubject<CPUInfo, Never>()

    override var cpuInfoPublisher: PassthroughSubject<CPUInfo, Never> {
        get { mockCPUSubject }
        set { mockCPUSubject = newValue }
    }

    private var mockCPUSubject = PassthroughSubject<CPUInfo, Never>()

    override func getCPUData() -> CPUInfo? {
        return mockCPUData
    }

    override func startMonitoring(interval: TimeInterval = 1) {
        return shouldStartMonitoring = true
    }

    override func stopMonitoring() {
        shouldStopMonitoring = true
    }

    func simulateCPUUpdate(_ data: CPUInfo) {
        mockCPUSubject.send(data)
    }
}

class MockStorageInfoService: StorageInfoService {
    var mockStorageInfo: StorageInfo?

    override func getStorageInfo() -> StorageInfo? {
        return mockStorageInfo
    }
}

class MockDeviceInfoService: DeviceInfoService {
    var mockDeviceInfo: DeviceInfo

    init(mockDeviceInfo: DeviceInfo) {
        self.mockDeviceInfo = mockDeviceInfo
    }

    override func getDeviceInfo() -> DeviceInfo {
        return mockDeviceInfo
    }
}
