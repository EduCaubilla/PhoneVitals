//
//  CustomGauge.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 2/10/25.
//

import SwiftUI

struct ThickLinearGaugeStyle: GaugeStyle {
    //MARK: - PROPERTIES
    var thickness: CGFloat = 10
    var lineColor: LinearGradient = LinearGradient(colors: [.red, .orange, .green], startPoint: .trailing, endPoint: .leading)

    private var cornerRadius : CGFloat { thickness / 2 }

    //MARK: - BODY
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: thickness)

                // Progress
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(lineColor)
                    .frame(
                        width: geometry.size.width,
                        height: thickness
                    )
                    .mask(
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .frame(width: geometry.size.width * configuration.value)
                            Spacer(minLength: 0)
                        }
                    )
            }
        }
        .frame(height: thickness)
    }

}
