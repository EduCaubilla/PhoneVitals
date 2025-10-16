//
//  HistorySystemDataView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

struct HistorySystemDataView: View {
    @Environment(\.modelContext) private var modelContext

    //MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                /// Background
                LinearGradient(
                    gradient: Gradient(colors: [.pvLightGreen, .pvWhite]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                /// Content
                ScrollView {
                    LazyVStack {
                        ForEach(0..<5) { index in
                            VStack(alignment: .leading, spacing: 6) {
                                Text("2 Oct 2025 - 04:47pm")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                HStack(alignment: .center, spacing: 5) {
                                    StateRoundIcon(
                                        score: 50.0, label: "Fair", color: .yellow
                                    )
                                        .padding(.leading, 10)

                                    LazyHGrid(rows: [
                                        GridItem(.fixed(30)),
                                        GridItem(.fixed(30)),
                                        GridItem(.fixed(30))
                                    ], spacing: 10) {
                                        ForEach(0..<5) { index in
                                            StateLinearIconBadge(
                                                title: SystemDataServiceSection.allCases[index],
                                                titleFont: .caption,
                                                subtitle: "Good",
                                                label: "",
                                                lineLevel: Double.random(in: 0..<100),
                                                lineThickness: 5.0,
                                                textAlignment: .leading
                                            )
                                            .frame(minWidth: 100, idealWidth: 140, maxWidth: .infinity, alignment: .center)
                                        }
                                    } //: LAZYHGRID - Overview data
                                    .frame(maxWidth: .infinity, alignment: .center)
                                } //: HSTACK
                                .padding(.vertical, 8)
                                .padding(.horizontal, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray, lineWidth: 0.2)
                                )

                            } //: VSTACK
                            .padding(.bottom, 15)
                        } //: FOR LOOP
                    } //: LAZYVSTACK
                    .navigationTitle(Text("Phone Vitals"))
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.horizontal, 20)
                    .toolbarBackground(.pvLightGreen, for: .navigationBar)
                } //: SCROLLVIEW
            } //: ZSTACK
        } //: NAVIGATION SATCK
    } //: MAIN VIEW
}

//MARK: - PREVIEW
#Preview {
    HistorySystemDataView()
}
