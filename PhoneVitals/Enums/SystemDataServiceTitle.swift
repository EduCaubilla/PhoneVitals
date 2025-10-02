//
//  SystemDataServiceTitle.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import Foundation

enum SystemDataServiceTitle: String, CaseIterable {
    case thermalState = "Thermal State"
    case battery = "Battery"
    case storage = "Storage"
    case ramMemory = "RAM Memory"
    case processor = "Processor"

    var id : String {
        return rawValue
    }
}
