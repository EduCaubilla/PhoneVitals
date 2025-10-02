//
//  StateRoundIcon.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import SwiftUI

struct StateRoundIcon: View {
    let currentOverviewValue: Double
    let currentOverviewTip: String
    let stateGradient: Gradient = Gradient(colors: [.red, .orange, .green])

    var body: some View {
        Gauge(value: currentOverviewValue, in: 0...100) {
            Label("Overall state", image: "phoneLoupeIcon")
                .fontWeight(.ultraLight)
                .foregroundStyle(.pvDarkGreen)
                .padding(.top, 5)
                .scaleEffect(1.3)
        } currentValueLabel: {
            Text(currentOverviewTip)
                .foregroundColor(.green)
                .padding(6)
        }
        .tint(stateGradient)
        .gaugeStyle(.accessoryCircular)
    }
}

#Preview {
    StateRoundIcon(currentOverviewValue: 50.0, currentOverviewTip: "Fair")
}
