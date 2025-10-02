//
//  HistorySystemDataView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

struct HistorySystemDataView: View {
    //MARK: - PROPERTIES
    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [SystemDataProfile]

    //MARK: - FUNCTIONS
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }

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
                            VStack(alignment: .leading, spacing: 10) {
                                Text("2 Oct 2025 - 04:47pm")
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)

                                HStack {
                                    StateRoundIcon(currentOverviewValue: 50.0, currentOverviewTip: "Fair")

                                    LazyHGrid(rows: [
                                        GridItem(.fixed(50)),
                                        GridItem(.fixed(50)),
                                        GridItem(.fixed(50))
                                    ], spacing: 10) {
                                        ForEach(0..<5) { index in
                                            StateLinearIconBadge(
                                                title: SystemDataServiceTitle.allCases[index].rawValue,
                                                titleFont: .callout,
                                                value: "Good",
                                                lineLevel: Double.random(in: 0..<100),
                                                lineThickness: 5.0,
                                                textAlignment: .leading
                                            )
                                            .padding(
                                                .horizontal
                                            )
                                        }
                                    } //: LAZYHGRID - Overview data
                                }
                            } //: VSTACK
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
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
        .modelContainer(for: SystemDataProfile.self, inMemory: true)
}
