//
//  DoubleTwoDecimals.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 14/10/25.
//

import Foundation


extension Double {
    var twoDecimals: Double {
        let result = ((self * 100) / 100).rounded() * 100
        return result
    }
}
