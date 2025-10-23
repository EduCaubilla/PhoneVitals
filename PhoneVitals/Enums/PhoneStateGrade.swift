//
//  PhoneStateGrade.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import Foundation

enum PhoneStateGrade : String {
    case outstanding = "Outstanding"
    case veryGood = "Very Good"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case bad = "Bad"
    case critical = "Critical"

    static func mapfromValue(_ value: Int) -> PhoneStateGrade {
        switch value {
            case 0..<10:
                return .critical
            case 10..<25:
                return .bad
            case 25..<40:
                return .poor
            case 40..<60:
                return .fair
            case 60..<75:
                return .good
            case 75..<90:
                return .veryGood
            case 90..<100:
                return .outstanding
            default:
                return .fair
        }
    }
}
