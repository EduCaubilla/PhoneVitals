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
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    let memoryInfoPublisher = PassthroughSubject<MemoryInfo, Never>()

    //MARK: - FUNCTIONS

    //MARK: - Monitoring process
    func startMonitoring(interval: TimeInterval = 1.0) {
        stopMonitoring()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.updateMemoryData()
            print("Completed Memory interval")
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func updateMemoryData() {
        guard let memoryInfo = getMemoryData() else { return }
        memoryInfoPublisher.send(memoryInfo)
        print("Update Memory data")
    }

    //MARK: - Get data
    func getMemoryData() -> MemoryInfo? {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size )

        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_VM_INFO, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            print(">>> Error retrieving memory stats <<<")
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

        let resultInfo = MemoryInfo(
            totalPhysical: Utils.bytesToGigaBytes(Double(totalPhysical)),
            availablePhysical: Utils.bytesToGigaBytes(Double(availablePhysical)),
            usedPhysical: Utils.bytesToGigaBytes(Double(usedPhysical)),
            activeMemory: Utils.bytesToGigaBytes(Double(activeMemory)),
            inactiveMemory: Utils.bytesToGigaBytes(Double(inactiveMemory)),
            wiredMemory: Utils.bytesToGigaBytes(Double(wiredMemory)),
            compressedMemory: Utils.bytesToGigaBytes(Double(compressedMemory)),
            freeMemory: Utils.bytesToGigaBytes(Double(freeMemory)),
            purgeableMemory: Utils.bytesToGigaBytes(Double(purgeableMemory)),
            appUsedMemory: Utils.bytesToGigaBytes(Double(appUsedMemory))
        )

        print("Memory result object:")
        dump(resultInfo)

        return resultInfo
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

        print("App memory usage is: \(memoryUsageResult) bytes")
        return memoryUsageResult
    }
}
