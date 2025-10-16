//
//  SystemOverviewCalculator.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 16/10/25.
//

import Foundation
import SwiftUI

class SystemOverviewCalculator {
    var weights: [SystemDataServiceSection: Double] {
        return [
            .thermalState: 0.3,    // Most critical - can damage device
            .battery: 0.15,    // Important but less critical
            .storage: 0.15,    // Important for functionality
            .ramMemory: 0.20,     // Critical for performance
            .processor: 0.20         // Important for responsiveness
        ]
    }

    func calculateOverviewData(profile: SystemDataProfileModel) -> OverviewData {
        let thermalScore: Double = calculateThermalScore(profile.thermalState)

        let batteryScore: Double = calculateBatteryScore(batteryLevel: profile.batteryLevel, batteryState: profile.batteryState)

        let storageScore: Double = calculateStorageScore(storageAvailable: profile.storageAvailable, storageCapacity: profile.storageCapacity)

        let memoryScore: Double = calculateMemoryScore(memoryAvailable: profile.memoryFree, memoryCapacity: profile.memoryCapacity)

        let cpuScore: Double = (profile.cpuUsageUser + profile.cpuUsageSystem)

        let overallScore = (
            thermalScore * weights[.thermalState]! +
            (100 - batteryScore) * weights[.battery]! + // We are calculating in 0-100 level so is the inverse to batt percentage.
            storageScore * weights[.storage]! +
            memoryScore * weights[.ramMemory]! +
            cpuScore * weights[.processor]!
        )

        let overallHealthLabel = getOverallInvertedScoreLabel(score: overallScore)
        let overallHealthColor: Color = getOverallScoreColor(score: overallScore)

        return OverviewData(
            overallHealthScore: overallScore,
            overallHealthLabel: overallHealthLabel,
            overallHealthColor: overallHealthColor,
            thermalScore: thermalScore,
            batteryScore: batteryScore,
            storageScore: storageScore,
            memoryScore: memoryScore,
            cpuScore: cpuScore
        )
    }

    func calculateThermalScore(_ thermalState: String) -> Double {
        return {
            switch thermalState.lowercased() {
                case "nominal": return 10
                case "fair": return 40
                case "serious": return 70
                case "critical": return 100
                default: return 50
            }
        }()
    }

    func calculateBatteryScore(batteryLevel: Double, batteryState: String) -> Double {
        let levelScore = batteryLevel * 100

        let stateMultiplier: Double = {
            switch batteryState.lowercased() {
                case "charging", "full": return 1.0
                case "unplugged": return batteryLevel > 0.2 ? 1.0 : 0.8
                default: return 1.0
            }
        }()

        return levelScore * stateMultiplier
    }

    func calculateStorageScore(storageAvailable: Double, storageCapacity: Double) -> Double {
        let availablePercentage = (storageAvailable / storageCapacity) * 100

        if availablePercentage >= 70 { return 100 }
        else if availablePercentage >= 50 { return 80 }
        else if availablePercentage >= 30 { return 50 }
        else if availablePercentage >= 15 { return 30 }
        else { return 10 }
    }

    func calculateMemoryScore(memoryAvailable: Double, memoryCapacity: Double) -> Double {
        return (memoryAvailable / memoryCapacity) * 100
    }

    func getOverallScoreLabel(score: Double) -> String {
        switch score {
            case 0..<25:
                return "Critical"
            case 25..<40:
                return "Poor"
            case 40..<60:
                return "Fair"
            case 60..<75:
                return "Good"
            case 75..<90:
                return "Very Good"
            case 90..<100:
                return "Excellent"
            default:
                return "Unknown"
        }
    }

    func getOverallInvertedScoreLabel(score: Double) -> String {
        switch score {
            case 0..<25:
                return "Superb"
            case 25..<40:
                return "Great"
            case 40..<60:
                return "Good"
            case 60..<75:
                return "Fair"
            case 75..<90:
                return "Poor"
            case 90..<100:
                return "Critical"
            default:
                return "Unknown"
        }
    }

    func getOverallScoreColor(score: Double) -> Color {
        switch score {
            case 0..<25:
                return .pvDarkGreen
            case 25..<40:
                return .green
            case 40..<60:
                return .darkYellow
            case 60..<75:
                return .orange
            case 75..<100:
                return .red
            case 90..<100:
                return .darkRed
            default:
                return .pvDarkGreen
        }
    }
}
