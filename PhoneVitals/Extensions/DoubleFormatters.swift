//
//  DoubleRounders.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 17/10/25.
//

import Foundation


extension Double {
    func roundCeil() -> Double {
        ceil(self)
    }

    func roundTwoDigits() -> Double {
        ((self * 100).rounded(.up)) / 100.0
    }

    func baseOneToBase100() -> Double {
        self * 100.0
    }

    func toStringTwoDigits() -> String {
        String(format: "%.2f", self)
    }

    func toStringWhole() -> String {
        String(format: "%.0f", self)
    }
}
