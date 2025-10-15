//
//  StateLinearIconBadge.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import SwiftUI

struct StateLinearIconBadge: View {
    //MARK: - PROPERTIES
    let title: SystemDataServiceTitle
    var titleFont : Font = .headline
    var subtitle: String = ""
    let value: String
    var lineLevel: CGFloat = 0.5
    var lineThickness: CGFloat = 10.0
    var textAlignment: HorizontalAlignment = .leading

    var reverseGradientList: [SystemDataServiceTitle] = [.battery, .thermalState]
    var fontRegularList: [Font] = [.body, .subheadline, .callout, .footnote, .caption]

    private var lineGradient: LinearGradient { LinearGradient(colors: [.red, .orange, .green], startPoint: .trailing, endPoint: .leading) }
    private var reverseLineGradient: LinearGradient { LinearGradient(colors: [.red, .orange, .green], startPoint: .leading, endPoint: .trailing) }

    private var isReverseGradient: Bool { reverseGradientList.contains(title) }
    private var isFontRegular:  Bool  { fontRegularList.contains(titleFont) }

    //MARK: - BODY
    var body: some View {
        VStack(alignment: textAlignment) {
            HStack {
                Text(title.displayName)
                    .font(titleFont)
                    .fontWeight(isFontRegular ? .regular : .medium)
                    .foregroundColor(.primary)

                if !subtitle.isEmpty {
                    Spacer()

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, -2)

            Gauge(value: lineLevel, in: 0.0...100.0) {}
                .gaugeStyle(
                    ThickLinearGaugeStyle(
                        thickness: lineThickness,
                        lineColor: isReverseGradient ? reverseLineGradient : lineGradient
                    )
                )

            if !value.isEmpty {
                Text(value)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    StateLinearIconBadge(title: .battery, titleFont: .footnote, subtitle: "Good", value: "", lineLevel: 50.0, lineThickness: 10.0, textAlignment: .center)
}
