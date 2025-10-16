//
//  StateRoundIcon.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import SwiftUI

struct StateRoundIcon: View {
    let score: Double
    let label: String
    let color: Color
    let stateGradient: Gradient = Gradient(colors: [.pvGreen, .green, .yellow, .orange, .red, .darkRed])

    var body: some View {
        Gauge(value: score, in: 0...100) {
            Label("Overall state", image: "phoneLoupeIcon")
                .fontWeight(.light)
                .foregroundStyle(.pvDarkGreen)
                .padding(.top, 4)
                .scaleEffect(1.4)
        } currentValueLabel: {
            Text(label)
                .fontWeight(.medium)
                .foregroundColor(color)
                .padding(5)
        }
        .tint(stateGradient)
        .gaugeStyle(.accessoryCircular)
    }
}

#Preview {
    StateRoundIcon(score: 50.0, label: "Good", color: .darkYellow)
}
