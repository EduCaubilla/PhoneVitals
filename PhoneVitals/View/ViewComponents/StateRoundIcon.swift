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
                .fontWeight(.ultraLight)
                .foregroundStyle(.pvDarkGreen)
                .padding(.top, 2)
                .scaleEffect(1.3)
        } currentValueLabel: {
            Text(label)
                .foregroundColor(color)
                .padding(6)
        }
        .tint(stateGradient)
        .gaugeStyle(.accessoryCircular)
    }
}

#Preview {
    StateRoundIcon(score: 50.0, label: "Fair", color: .yellow)
}
