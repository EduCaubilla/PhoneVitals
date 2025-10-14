//
//  Utils.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 14/10/25.
//

import Foundation


struct Utils {
    static func bytesToGigaBytes(_ bytes: Double) -> Double {
        return ((Double(bytes) / 1000 / 1000 / 1000) * 100).rounded() / 100
    }

    static func bytesToGigaBytes(_ bytes: UInt64) -> Double {
        return ((Double(bytes) / 1024 / 1024 / 1024) * 100).rounded() / 100
    }
}
