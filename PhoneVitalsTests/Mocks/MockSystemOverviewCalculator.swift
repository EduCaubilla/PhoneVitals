//
//  MockSystemOverviewCalculator.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 24/10/25.
//

import SwiftUI
@testable import PhoneVitals

class MockSystemOverviewCalculator: SystemOverviewCalculator {

    //MARK: - PROPERTIES
    var mockOverviewData: OverviewData?
    var lastProfileReceived: SystemDataProfileModel?

    var mockScoreLabel = "Good Test"
    var mockInvertedScoreLabel = "Good Test Inv."
    var mockScoreColor: Color = .yellow
    var overallScoreLabelCount: Int = 0
    var overallInvertedScoreLabelCount: Int = 0
    var overallScoreColorCount: Int = 0

    //MARK: - FUNCTIONS
    override func calculateOverviewData(profile: PhoneVitals.SystemDataProfileModel) -> PhoneVitals.OverviewData {
        overviewDataCallCount += 1
        lastProfileReceived = profile
        return overviewData ?? OverviewData.mock()
    }
    
    override func getOverallScoreLabel(score: Double) -> String {
        overallScoreLabelCount += 1
        return mockScoreLabel
    }
    
    override func getOverallInvertedScoreLabel(score: Double) -> String {
        overallInvertedScoreLabelCount += 1
        return mockInvertedScoreLabel
    }
    
    override func getOverallScoreColor(score: Double) -> Color {
        overallScoreColorCount += 1
        return mockScoreColor
    }
}
