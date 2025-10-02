//
//  StateLinearIconBadge.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import SwiftUI

struct StateLinearIconBadge: View {
    //MARK: - PROPERTIES
    let title: String
    var titleFont : Font = .headline
    var subtitle: String = ""
    let value: String
    var lineLevel: CGFloat
    var lineThickness: CGFloat = 10.0
    var textAlignment: HorizontalAlignment = .leading

    private var lineGradient: LinearGradient { LinearGradient(colors: [.red, .orange, .green], startPoint: .trailing, endPoint: .leading) }
    private var batteryLineGradient: LinearGradient { LinearGradient(colors: [.red, .orange, .green], startPoint: .leading, endPoint: .trailing) }

    private var isBatteryGradient: Bool { title == "Battery" }
    private var isFontRegular:  Bool  { titleFont == .body || titleFont == .subheadline || titleFont == .callout }

    //MARK: - BODY
    var body: some View {
        VStack(alignment: textAlignment) {
            HStack {
                Text(title)
                    .font(titleFont)
                    .fontWeight(isFontRegular ? .regular : .medium)
                    .foregroundColor(.primary)

                if !subtitle.isEmpty {
                    Spacer()

                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 3)
                }
            }

            Gauge(value: lineLevel, in: 0...100) {}
                .gaugeStyle(ThickLinearGaugeStyle(thickness: lineThickness, lineColor: isBatteryGradient ? batteryLineGradient : lineGradient))

            if !value.isEmpty {
                Text(value)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 3)
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    StateLinearIconBadge(title: "Title", titleFont: .headline, subtitle: "", value: "Good", lineLevel: 50.0, lineThickness: 10.0, textAlignment: .center)
}
