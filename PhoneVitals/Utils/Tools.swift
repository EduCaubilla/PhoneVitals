//
//  Utils.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 14/10/25.
//

import Foundation
import SwiftUI

struct Tools {
    static func bytesToGigaBytes(_ bytes: Double) -> Double {
        return ((Double(bytes) / 1000 / 1000 / 1000) * 100).rounded() / 100
    }

    static func bytesToGigaBytes(_ bytes: Int64) -> Double {
        return ((Double(bytes) / 1000 / 1000 / 1000) * 100).rounded() / 100
    }
}
