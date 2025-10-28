//
//  SystemOverviewCalculationProtocol.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 24/10/25.
//

import Foundation
import SwiftUI

protocol SystemOverviewCalculationProtocol {
    var overviewData: OverviewData? { get set }
    var overviewDataCallCount: Int { get set }

    func calculateOverviewData(profile: SystemDataProfileModel) -> OverviewData
    func getOverallScoreLabel(score: Double) -> String
    func getOverallInvertedScoreLabel(score: Double) -> String
    func getOverallScoreColor(score: Double) -> Color
}
