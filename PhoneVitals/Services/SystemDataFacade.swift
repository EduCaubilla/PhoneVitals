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
    private let memory : MemoryInfoService?
    private var memoryData : MemoryInfo?

    private let device : DeviceInfoService

    private let systemDataSubject = PassthroughSubject<SystemDataProfileModel?, Never>()
    private let deviceDataSubject = PassthroughSubject<DeviceInfo, Never>()

    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    //MARK: - Publishers for the viewModel to subscribe to
    var systemDataPublisher : AnyPublisher<SystemDataProfileModel?, Never> {
        systemDataSubject.eraseToAnyPublisher()
    }

    var deviceDataPublisher : AnyPublisher<DeviceInfo, Never> {
        deviceDataSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }

    var cancellables : Set<AnyCancellable> = []

    //MARK: - INITIALIZER
    init(memory: MemoryInfoService = MemoryInfoService(),
         device: DeviceInfoService = DeviceInfoService()) {
        self.memory = memory
        self.device = device

        Task {
            await fetchMemoryData()
        }
    }

    //MARK: - DEINITIALIZER
    deinit {
        memory?.stopMonitoring()
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
            memoryUsage: memoryUsage,
            memoryCapacity: memoryCapacity,
            memoryFree: memoryFree,
            cpuUsage: cpuUsage,
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
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let capacity = attributes[FileAttributeKey.systemSize] as! Double
        let capacityResult = Utils.bytesToGigaBytes(capacity)
        return capacityResult
    }

    @MainActor
    private func getStorageUsed() -> Double {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let capacity = attributes[FileAttributeKey.systemSize] as! Double
        let freeSize = attributes[FileAttributeKey.systemFreeSize] as! Double
        let usage = capacity - freeSize
        let usageResult = Utils.bytesToGigaBytes(usage)
        return usageResult
    }

    @MainActor
    private func getStorageAvailable() -> Double {
        let fileManager = FileManager.default
        let attributes = try! fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let freeSize = attributes[FileAttributeKey.systemFreeSize] as! Double
        let freeSizeResult = Utils.bytesToGigaBytes(freeSize)
        return freeSizeResult
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
    private func getCpuUsage() -> Double {
        var cpuUsage: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)

        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        guard threadsResult == KERN_SUCCESS else {
            return 0.0
        }

        for index in 0..<Int(threadsCount) {
            var threadInfo = thread_basic_info()
            var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)

            let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                }
            }

            guard infoResult == KERN_SUCCESS else { break }

//            let threadBasicInfo = threadInfo as thread_basic_info
            let threadBasicInfo = threadInfo
            if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                cpuUsage += Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }

        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))

        return cpuUsage
    }
}
