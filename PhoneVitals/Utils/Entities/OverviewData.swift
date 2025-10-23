//
//  SystemOverviewData.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 16/10/25.
//

import Foundation
import SwiftUI

struct OverviewData {
    var overallHealthScore: Double
    var overallHealthLabel: String
    var overallHealthColor: Color

    var thermalScore: Double
    var batteryScore: Double
    var storageScore: Double
    var memoryScore: Double
    var cpuScore: Double
}
