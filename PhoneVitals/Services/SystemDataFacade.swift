//
//  SystemDataFacade.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 10/10/25.
//

import Foundation
import SwiftUI
import Combine

class SystemDataFacade : ObservableObject, SystemDataFacadeProtocol {

    //MARK: - PROPERTIES
    private let storage : StorageInfoService?

    private let memory : MemoryInfoService?
    private var memoryData : MemoryInfo?

    private let device : DeviceInfoService

    private let cpu : CPUInfoService?
    private var cpuData : CPUInfo?

    private let systemDataSubject = PassthroughSubject<SystemDataProfileModel?, Never>()
    private let deviceDataSubject = PassthroughSubject<DeviceInfo, Never>()
    private let cpuDataSubject = PassthroughSubject<CPUInfo, Never>()

    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    //MARK: - Publishers for the viewModel to subscribe to
    var systemDataPublisher : AnyPublisher<SystemDataProfileModel?, Never> {
        systemDataSubject.eraseToAnyPublisher()
    }

    var deviceDataPublisher : AnyPublisher<DeviceInfo, Never> {
        deviceDataSubject.eraseToAnyPublisher()
    }

    var cpuDataPublisher : AnyPublisher<CPUInfo, Never> {
        cpuDataSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }

    var cancellables : Set<AnyCancellable> = []

    //MARK: - INITIALIZER
    init(memory: MemoryInfoService = MemoryInfoService(),
         device: DeviceInfoService = DeviceInfoService(),
         cpu: CPUInfoService = CPUInfoService(),
         storage: StorageInfoService = StorageInfoService()
    ) {
        self.storage = storage
        self.memory = memory
        self.device = device
        self.cpu = cpu

        Task {
            await fetchMemoryData()
            await fetchCPUData()
        }
    }

    //MARK: - DEINITIALIZER
    deinit {
        memory?.stopMonitoring()
        cpu?.stopMonitoring()
        cancellables.forEach { $0.cancel() }
    }

    //MARK: - FUNCTIONS

    //MARK: - Memory data monitor
    func fetchMemoryData() async {
        self.memoryData = memory?.getMemoryData()

        memory?.memoryInfoPublisher
            .sink { info in
                self.memoryData = info
            }
            .store(in: &cancellables)

        memory?.startMonitoring()
    }

    //MARK: - CPU data monitor
    func fetchCPUData() async {
        self.cpuData = cpu?.getCPUData()

        cpu?.cpuInfoPublisher
            .sink { info in
                self.cpuData = info
            }
            .store(in: &cancellables)

        cpu?.startMonitoring()
    }

    //MARK: - Device data
    func getAllDeviceData() async -> DeviceInfo {
        return device.getDeviceInfo()
    }

    //MARK: - System data
    func getAllSystemData() async -> SystemDataProfileModel {

        let thermalState = await getThermalState()
        let batteryLevel = await getBatteryLevel()
        let batteryState = await getBatteryState()
        let storageCapacity = await getStorageCapacity()
        let storageUsed = await getStorageUsed()
        let storageAvailable = await getStorageAvailable()
        let memoryUsage = await getMemoryUsage()
        let memoryCapacity = await getMemoryCapacity()
        let memoryFree = await getMemoryFree()
        let cpuUsageUser = await getCpuUsageUser()
        let cpuUsageSystem = await getCpuUsageSystem()
        let cpuUsageInactive = await getCpuUsageInactive()

        return SystemDataProfileModel(
            id: nil,
            thermalState: thermalState,
            batteryLevel: batteryLevel,
            batteryState: batteryState,
            storageCapacity: storageCapacity,
            storageUsed: storageUsed,
            storageAvailable: storageAvailable,
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            cpuUsageUser: cpuUsageUser,
            cpuUsageSystem: cpuUsageSystem,
            cpuUsageInactive: cpuUsageInactive,
            timestamp: Date.now
        )
    }

    @MainActor
    private func getThermalState() -> String {
        let thermalState = ProcessInfo.processInfo.thermalState
        return ThermalStateGrade.mapFromOriginThermalStateToString(state: thermalState)
    }

    @MainActor
    private func getBatteryLevel() -> Double {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        return Double(batteryLevel)
    }

    @MainActor
    private func getBatteryState() -> String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryState = UIDevice.current.batteryState
        return batteryState.displayName
    }

    @MainActor
    private func getStorageCapacity() -> Double {
        return storage?.getStorageInfo()?.totalCapacity ?? 0
    }

    @MainActor
    private func getStorageUsed() -> Double {
        return storage?.getStorageInfo()?.usedCapacity ?? 0
    }

    @MainActor
    private func getStorageAvailable() -> Double {
        return storage?.getStorageInfo()?.availableCapacity ?? 0
    }

    @MainActor
    private func getMemoryUsage() -> Double {
        let result = (memoryData?.activeMemory ?? 0) + (memoryData?.wiredMemory ?? 0)
        return result
    }

    @MainActor
    private func getMemoryCapacity() -> Double {
        let result = memoryData?.totalPhysical ?? 0
        return result
    }

    @MainActor
    private func getMemoryFree() -> Double {
        let result = (memoryData?.totalPhysical ?? 0) - (memoryData?.usedPhysical ?? 0)
        return result
    }

    @MainActor
    func getCpuUsageUser() -> Double {
        let result = cpuData?.userCpu ?? 0
        return result
    }

    @MainActor
    func getCpuUsageSystem() -> Double {
        let result = cpuData?.systemCpu ?? 0
        return result
    }

    @MainActor
    func getCpuUsageInactive() -> Double {
        let result = cpuData?.idleCpu ?? 0
        return result
    }
}
