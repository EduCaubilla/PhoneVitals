//
//  CpuInfoService.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 15/10/25.
//

import Foundation
import Combine

class CPUInfoService {
    //MARK: - PROPERTIES
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    let cpuInfoPublisher = PassthroughSubject<CPUInfo, Never>()

    //MARK: - FUNCTIONS

    //MARK: - Monitoring process
    func startMonitoring(interval: TimeInterval = 1) {
        stopMonitoring()

        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                self?.updateCPUData()
                print("Completed CPU interval")
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func updateCPUData() {
        guard let cpuInfo = getCPUData() else { return }
        cpuInfoPublisher.send(cpuInfo)
        print("Update CPU data")
    }

    //MARK: - Get data
    func getProcessorCount() -> (processorCount: Int, activeProcessorCount: Int) {
        let processorCount = ProcessInfo.processInfo.processorCount
        let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
        return (processorCount, activeProcessorCount)
    }

    func getCPUData() -> CPUInfo? {
            var cpuInfo: processor_info_array_t?
            var numCPUInfo: mach_msg_type_number_t = 0
            var numCPUs: natural_t = 0

            let result = host_processor_info(mach_host_self(),
                                             PROCESSOR_CPU_LOAD_INFO,
                                             &numCPUs,
                                             &cpuInfo,
                                             &numCPUInfo)

            guard result == KERN_SUCCESS else { return nil }

            var totalSystemTime: UInt32 = 0
            var totalUserTime: UInt32 = 0
            var totalIdleTime: UInt32 = 0
            var totalNiceTime: UInt32 = 0

            if let cpuInfo = cpuInfo {
                for i in 0..<Int(numCPUs) {
                    let cpuLoadInfo = cpuInfo.advanced(by: Int(CPU_STATE_MAX) * i)
                        .withMemoryRebound(to: integer_t.self, capacity: Int(CPU_STATE_MAX)) { $0 }

                    totalSystemTime += UInt32(cpuLoadInfo[Int(CPU_STATE_SYSTEM)])
                    totalUserTime += UInt32(cpuLoadInfo[Int(CPU_STATE_USER)])
                    totalIdleTime += UInt32(cpuLoadInfo[Int(CPU_STATE_IDLE)])
                    totalNiceTime += UInt32(cpuLoadInfo[Int(CPU_STATE_NICE)])
                }

                vm_deallocate(mach_task_self_,
                              vm_address_t(bitPattern: cpuInfo),
                              vm_size_t(numCPUInfo) * vm_size_t(MemoryLayout<integer_t>.size))
            }

            let totalTicks = Double(totalSystemTime + totalUserTime + totalIdleTime + totalNiceTime)

            let resultProcessor = getProcessorCount()

            let resultCPUInfo = CPUInfo(
                totalProcessors: resultProcessor.0,
                processorsUsed: resultProcessor.1,
                systemCpu: Double(totalSystemTime) / totalTicks * 100,
                userCpu: Double(totalUserTime) / totalTicks * 100,
                idleCpu: Double(totalIdleTime) / totalTicks * 100,
                niceCpu: Double(totalNiceTime) / totalTicks * 100
            )

            print("Response CPU: ")
            dump(resultCPUInfo)

            return resultCPUInfo
        }
}
