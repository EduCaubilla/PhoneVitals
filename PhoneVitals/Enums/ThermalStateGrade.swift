//
//  ThermalStateGrade.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 3/10/25.
//

import Foundation

enum ThermalStateGrade : String, CaseIterable, Identifiable {
    case nominal
    case fair
    case serious
    case critical

    var id : String { rawValue }

    var displayValue : String {
        switch self {
            case .nominal:
                return "Very good"
            case .fair:
                return "Good"
            case .serious:
                return "Bad"
            case .critical:
                return "Critical"
        }
    }

    var originalThermalState: ProcessInfo.ThermalState {
        switch self {
            case .nominal:
                return .nominal
            case .fair:
                return .fair
            case .serious:
                return .serious
            case .critical:
                return .critical
        }
    }

    static func mapFromDisplayValueToLevel(_ displayValue: String) -> CGFloat {
        switch displayValue {
            case ThermalStateGrade.nominal.displayValue:
                return 90.0
            case ThermalStateGrade.fair.displayValue:
                return 70.0
            case ThermalStateGrade.serious.displayValue:
                return 50.0
            case ThermalStateGrade.critical.displayValue:
                return 30.0
            default:
                return 0.0
        }
    }

    static func mapFromOriginThermalStateToString(state: ProcessInfo.ThermalState) -> String {
        switch state {
            case .nominal:
                return ThermalStateGrade.nominal.displayValue
            case .fair:
                return ThermalStateGrade.fair.displayValue
            case .serious:
                return ThermalStateGrade.serious.displayValue
            case .critical:
                return ThermalStateGrade.critical.displayValue
            default:
                return ThermalStateGrade.fair.displayValue
        }
    }

    static func mapFromOriginThermalStateToLevel(state: ProcessInfo.ThermalState) -> CGFloat {
        switch state {
            case .nominal:
                return 85.0
            case .fair:
                return 70.0
            case .serious:
                return 50.0
            case .critical:
                return 25.0
            default:
                return 50.0
        }
    }

    static func mapFromOriginStringToLevel(state: String) -> CGFloat {
        if let stateGrade = ThermalStateGrade(rawValue: state) {
            return mapFromOriginThermalStateToLevel(state: stateGrade.originalThermalState)
        } else {
            return 50.0
        }
    }

    static func mapFromOriginStringToGradeString(state: String) -> String {
        if let stateGrade = ThermalStateGrade(rawValue: state) {
            return stateGrade.displayValue
        } else {
            return "Fair"
        }
    }
}
