//
//  BatteryState.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 14/10/25.
//

import Foundation
import SwiftUI

extension UIDevice.BatteryState {
    var displayName: String {
        switch self {
            case .unknown:
                return "Unknown"
            case .unplugged:
                return "Unplugged"
            case .charging:
                return "Charging"
            case .full:
                return "Full"
            @unknown default:
                return "Unknown"
        }
    }

    static func mapFromStringToInt(_ battString: String) -> Int {
        switch battString {
            case "Unknown":
                return 0
            case "Unplugged":
                return 1
            case "Charging":
                return 2
            case "Full":
                return 3
            default:
                return 1
        }
    }
}
