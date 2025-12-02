//
//  MemoryInfoService.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 13/10/25.
//

import Foundation
import UIKit
import Combine

class MemoryInfoService {
    //MARK: - PROPERTIES
    private var monitoringTask: Task<Void, Never>?

    var memoryInfoPublisher = PassthroughSubject<MemoryInfo, Never>()

    //MARK: - FUNCTIONS

    //MARK: - Monitoring process
    func startMonitoring(interval: TimeInterval = 1.0) {
        stopMonitoring()

        monitoringTask = Task { [weak self] in
            while !Task.isCancelled {
                self?.updateMemoryData()
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }

    func stopMonitoring() {
        monitoringTask?.cancel()
        monitoringTask = nil
    }

    nonisolated func updateMemoryData() {
        do {
            let memoryInfo = try getMemoryData()
            Task { @MainActor in
                guard let memoryInfo = memoryInfo else { return }
                memoryInfoPublisher.send(memoryInfo)
            }
        } catch {
            print("Error updating memory info in MemoryInforService.updateMemoryData(): \(error)")
        }
    }

    //MARK: - Get data
    func getMemoryData() throws -> MemoryInfo? {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size )

        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_VM_INFO, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            print("Error retrieving memory stats in MemoryInforService.getMemoryData()")
            return nil
        }

        let pageSize = UInt64(vm_kernel_page_size)

        let totalPhysical = ProcessInfo.processInfo.physicalMemory

        let activeMemory = UInt64(stats.active_count) * pageSize
        let inactiveMemory = UInt64(stats.inactive_count) * pageSize
        let wiredMemory = UInt64(stats.wire_count) * pageSize
        let compressedMemory = UInt64(stats.compressions) * pageSize
        let freeMemory = UInt64(stats.free_count) * pageSize
        let purgeableMemory = UInt64(stats.purgeable_count) * pageSize

        let availablePhysical = freeMemory + inactiveMemory + purgeableMemory
        let usedPhysical = activeMemory + wiredMemory + compressedMemory

        let appUsedMemory = getAppMemoryUsage()

        let resultMemoryInfo = MemoryInfo(
            totalPhysical: Tools.bytesToGigaBytes(Double(totalPhysical)),
            availablePhysical: Tools.bytesToGigaBytes(Double(availablePhysical)),
            usedPhysical: Tools.bytesToGigaBytes(Double(usedPhysical)),
            activeMemory: Tools.bytesToGigaBytes(Double(activeMemory)),
            inactiveMemory: Tools.bytesToGigaBytes(Double(inactiveMemory)),
            wiredMemory: Tools.bytesToGigaBytes(Double(wiredMemory)),
            compressedMemory: Tools.bytesToGigaBytes(Double(compressedMemory)),
            freeMemory: Tools.bytesToGigaBytes(Double(freeMemory)),
            purgeableMemory: Tools.bytesToGigaBytes(Double(purgeableMemory)),
            appUsedMemory: Tools.bytesToGigaBytes(Double(appUsedMemory))
        )

        return resultMemoryInfo
    }

    func getAppMemoryUsage() -> UInt64 {
        var memoryUsageResult: UInt64 = 0

        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size)

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            return memoryUsageResult
        }

        memoryUsageResult = UInt64(info.resident_size)

        return memoryUsageResult
    }
}
