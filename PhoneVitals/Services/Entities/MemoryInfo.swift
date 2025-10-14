//
//  MemoryInfo.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 13/10/25.
//

import Foundation

struct MemoryInfo {
    var totalPhysical: Double?
    var availablePhysical: Double?
    var usedPhysical: Double?

    var activeMemory: Double?
    var inactiveMemory: Double?
    var wiredMemory: Double?
    var compressedMemory: Double?
    var freeMemory: Double?
    var purgeableMemory: Double?
    var appUsedMemory: Double?

    var totalPhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(totalPhysical ?? 0), countStyle: .memory) }
    var availablePhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(availablePhysical ?? 0), countStyle: .memory) }
    var usedPhysicalFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(usedPhysical ?? 0), countStyle: .memory) }

    var activeMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(activeMemory ?? 0), countStyle: .memory) }
    var inactiveMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(inactiveMemory ?? 0), countStyle: .memory) }
    var wiredMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(wiredMemory ?? 0), countStyle: .memory) }
    var compressedMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(compressedMemory ?? 0), countStyle: .memory) }
    var freeMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(freeMemory ?? 0), countStyle: .memory) }
    var purgeableMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(purgeableMemory ?? 0), countStyle: .memory) }

    var appUsedMemoryFormatted: String { ByteCountFormatter.string(fromByteCount: Int64(appUsedMemory ?? 0), countStyle: .memory) }
}
