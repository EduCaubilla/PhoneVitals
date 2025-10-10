//
//  ContentView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

struct MainSystemDataView: View {
    //MARK: - PROPERTIES
    @Environment(\.modelContext) private var modelContext

    @State private var currentOverviewTip: String = "Good"
    @State private var currentOverviewValue: Double = 80.0

    private let minValue = 0.0
    private let maxValue = 100.0

    //MARK: - INITIALIZER
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.pvDarkGreen)]
    }

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
                    VStack(alignment: .leading, spacing: 0) {
                        //MARK: - Overview
                        VStack(alignment: .leading, spacing: 0) {
                            /// Overview Title
                            Text("Overview")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, -8)

                            /// Overview Icon
                            HStack(alignment: .top, spacing: 5) {
                                Spacer()

                                StateRoundIcon(currentOverviewValue: currentOverviewValue, currentOverviewTip: currentOverviewTip)
                                .scaleEffect(2)
                                .frame(width: 125, height: 125, alignment: .center)

                                Spacer()
                            }
                        } //: VSTACK - Overview

                        /// Overview Data
                        LazyHGrid(rows: [
                            GridItem(.fixed(70)),
                            GridItem(.fixed(70)),
                            GridItem(.fixed(70))
                        ], spacing: 0) {
                            ForEach(0..<5) { index in
                                StateLinearIconBadge(title: SystemDataServiceTitle.allCases[index].rawValue, titleFont: .callout, value: "Good", lineLevel: 80.0, lineThickness: 10.0, textAlignment: .leading)
                                .padding(.horizontal)
                            }
                            .frame(minWidth: 100, idealWidth: 200, maxWidth: 250, alignment: .top)
                        } //: LAZYHGRID - Overview data
                        .frame(maxWidth: .infinity, maxHeight: 280, alignment: .center)

                        Divider()
                            .padding(10)

                        //MARK: - Section Device Information
                        VStack(alignment: .center) {
                            Text("Device Information")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)

                            Grid(alignment: .top, verticalSpacing: 10) {
                                GridRow {
                                    Text("John's iPhone") //Name
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                    Text("iPhone 14 Plus") //Model
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }

                                GridRow {
                                    Text("iOS18") // System Name
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                                    Text("iOS 18.6.2") // System Version
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                        .padding(.vertical, 5)

                        //MARK: - Additional Information
                        VStack(alignment: .center, spacing: 0) {
                            Grid(alignment: .top, horizontalSpacing: 25, verticalSpacing: 10) {

                                GridRow (alignment: .top) {

                                    //MARK: - Section Thermal State
                                    VStack(alignment: .center) {
                                        StateLinearIconBadge(title: "Thermal State", titleFont: .headline, value: "Good", lineLevel: 85.0, lineThickness: 7, textAlignment: .center)
                                    }

                                    //MARK: - Section Battery
                                    VStack(alignment: .center) {
                                        StateLinearIconBadge(title: "Battery", titleFont: .headline, value: "76%", lineLevel: 85.0, lineThickness: 7, textAlignment: .center)
                                        Text("State - Unplugged")
                                            .foregroundStyle(.secondary)
                                            .font(.footnote)
                                    }
                                } //: ROW 1
                                .padding(.bottom, 5)

                                GridRow (alignment: .top) {

                                    //MARK: - Section Storage
                                    VStack(alignment: .center) {
                                        StateLinearIconBadge(title: "Storage", titleFont: .headline, value: "", lineLevel: 45.0, lineThickness: 7, textAlignment: .center)

                                        VStack {
                                            Text("Total - 127,85 Gb")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                            Text("Free - 20,25 Gb")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                        }
                                        .padding(.top, 3)
                                    }

                                    //MARK: - Section RAM Memory
                                    VStack(alignment: .center) {
                                        StateLinearIconBadge(title: "RAM Memory", titleFont: .headline, value: "", lineLevel: 85.0, lineThickness: 7, textAlignment: .center)

                                        VStack {
                                            Text("Total - 127,85 Gb")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                            Text("Free - 20,25 Gb")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                        }
                                        .padding(.top, 3)
                                    }
                                } //: ROW 2
                                .padding(.bottom, 5)

                                GridRow (alignment: .top) {

                                    //MARK: - Section Processor
                                    VStack(alignment: .center) {
                                        StateLinearIconBadge(title: "Processor", titleFont: .headline, value: "", lineLevel: 85.0, lineThickness: 7, textAlignment: .center)

                                        VStack {
                                            Text("User - 2.50%")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                            Text("System - 3.17%")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                            Text("Inactive - 94.23%")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                        }
                                        .padding(.top, 3)
                                    }
                                } //: ROW 3
                                .padding(.bottom, 5)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)

                    } //: VSTACK MAIN
                    .navigationTitle(Text("Phone Vitals"))
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.horizontal, 20)
                    .toolbarBackground(.pvLightGreen, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: HistorySystemDataView()){
                                Image(systemName: "clock.arrow.circlepath")
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                } //: SCROLLVIEW
            } //: ZSTACK
        } //: NAV
    } //: VIEW
}

//MARK: - PREVIEW
#Preview {
    MainSystemDataView()
        .modelContainer(for: SystemDataProfileDTO.self, inMemory: true)
}
