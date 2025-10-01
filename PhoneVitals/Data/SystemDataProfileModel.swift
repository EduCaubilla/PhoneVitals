//
//  Item.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import SwiftData

@Model
final class SystemDataProfile {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
