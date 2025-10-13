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

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    let memoryInfoPublisher = PassthroughSubject<MemoryInfo, Never>()

    func startMonitoring(interval: TimeInterval = 1.0) {
        stopMonitoring()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.updateMemoryData()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func updateMemoryData() {
        guard let memoryInfo = getMemoryData() else { return }
        memoryInfoPublisher.send(memoryInfo)
    }

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

        return MemoryInfo(
            totalPhysical: totalPhysical,
            availablePhysical: availablePhysical,
            usedPhysical: usedPhysical,
            activeMemory: activeMemory,
            inactiveMemory: inactiveMemory,
            wiredMemory: wiredMemory,
            compressedMemory: compressedMemory,
            freeMemory: freeMemory,
            purgeableMemory: purgeableMemory,
            appUsedMemory: appUsedMemory
        )
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

struct MemoryInfo {
    var totalPhysical: UInt64 = 0
    var availablePhysical: UInt64 = 0
    var usedPhysical: UInt64 = 0

    var activeMemory: UInt64 = 0
    var inactiveMemory: UInt64 = 0
    var wiredMemory: UInt64 = 0
    var compressedMemory: UInt64 = 0
    var freeMemory: UInt64 = 0
    var purgeableMemory: UInt64 = 0
    var appUsedMemory: UInt64 = 0

    var usagePercentege: Double {
        guard totalPhysical > 0 else { return 0 }
        return Double(usedPhysical) / Double(totalPhysical) * 100
    }

    var totalPhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(totalPhysical), countStyle: .memory) }
    var availablePhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(availablePhysical), countStyle: .memory) }
    var usedPhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(usedPhysical), countStyle: .memory) }

    var activeMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(activeMemory), countStyle: .memory) }
    var inactiveMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(inactiveMemory), countStyle: .memory) }
    var wiredMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(wiredMemory), countStyle: .memory) }
    var compressedMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(compressedMemory), countStyle: .memory) }
    var freeMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(freeMemory), countStyle: .memory) }
    var purgeableMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(purgeableMemory), countStyle: .memory) }

    var appUsedMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(appUsedMemory), countStyle: .memory) }
}
