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

        let batteryScore: Double = calculateBatteryScore(batteryLevel: profile.batteryLevel, batteryState: profile.batteryState, batteryLowMode: profile.batteryLowPowerMode)

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
                case "nominal": return 12.5
                case "fair": return 35.0
                case "serious": return 65.0
                case "critical": return 87.5
                default: return 50
            }
        }()
    }

    func calculateBatteryScore(batteryLevel: Double, batteryState: String, batteryLowMode: Bool) -> Double {
        let levelScore : Double = {
            switch batteryLevel {
                case 0...20.0: return 20.0
                case 21.0...40.0: return 70.0
                case 41.0...80.0: return 95.0
                case 81.0...99.0: return 80.0
                default: return 50.0
            }
        }()

        let stateMultiplier: Double = {
            switch batteryState.lowercased() {
                case "charging", "full": return 1.0
                case "unplugged": return batteryLevel > 0.2 ? 1.0 : (batteryLowMode ? 0.8 : 0.6)
                default: return 1.0
            }
        }()

        print("Battery Level: \(batteryLevel), State: \(batteryState), Level Score: \(levelScore), State Multiplier: \(stateMultiplier) --> TOTAL SCORE: \(levelScore * stateMultiplier)")
        return levelScore * stateMultiplier
    }

    func calculateStorageScore(storageAvailable: Double, storageCapacity: Double) -> Double {
        let availablePercentage = (storageAvailable / storageCapacity) * 100

        if availablePercentage >= 20 { return 100 }
        else if availablePercentage >= 10 { return 70 }
        else if availablePercentage >= 5 { return 40 }
        else if availablePercentage >= 3 { return 15 }
        else { return 5 }
    }

    func calculateMemoryScore(memoryAvailable: Double, memoryCapacity: Double) -> Double {
        return (memoryAvailable / memoryCapacity) * 100
    }

    func getOverallScoreLabel(score: Double) -> String {
        switch score {
            case 0..<15:
                return "Critical"
            case 15..<40:
                return "Poor"
            case 40..<60:
                return "Fair"
            case 60..<75:
                return "Good"
            case 75..<90:
                return "Great"
            case 90...100:
                return "Superb"
            default:
                return "Unknown"
        }
    }

    func getOverallInvertedScoreLabel(score: Double) -> String {
        switch score {
            case 0..<15:
                return "Superb"
            case 15..<40:
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
            case 0..<15:
                return .teal.opacity(0.6)
            case 15..<40:
                return .green
            case 40..<60:
                return .darkYellow
            case 60..<75:
                return .orange
            case 75..<90:
                return .red
            case 90..<100:
                return .darkRed
            default:
                return .primary
        }
    }
}
