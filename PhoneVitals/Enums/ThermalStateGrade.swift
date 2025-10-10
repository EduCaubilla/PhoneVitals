//
//  ThermalStateGrade.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 3/10/25.
//

import Foundation

enum ThermalStateGrade : String {
    case nominal  = "Very good"
    case fair = "Good"
    case serious = "Bad"
    case critical = "Critical"

    static func mapFromOriginThermalState(state: Int) -> String {
        switch state {
            case 0:
                return ThermalStateGrade.nominal.rawValue
            case 1:
                return ThermalStateGrade.fair.rawValue
            case 2:
                return ThermalStateGrade.serious.rawValue
            case 3:
                return ThermalStateGrade.critical.rawValue
            default:
                return ThermalStateGrade.fair.rawValue
        }
    }
}
