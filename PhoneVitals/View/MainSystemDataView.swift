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

    @StateObject var viewModel : MainSystemDataViewModel

    //MARK: - INITIALIZER
    init(viewModel: MainSystemDataViewModel = MainSystemDataViewModel()) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.pvDarkGreen)]
        _viewModel = StateObject(wrappedValue: viewModel)
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
                if viewModel.isLoading {
                    ProgressView()
                } else if let systemData = viewModel.systemData {
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
                                    .padding(.leading, 10)

                                /// Overview Icon
                                HStack(alignment: .top, spacing: 5) {
                                    Spacer()

                                    StateRoundIcon(
                                        score: viewModel.overviewData?.overallHealthScore ?? 50.0,
                                        label: viewModel.overviewData?.overallHealthLabel ?? "Fair",
                                        color: viewModel.overviewData?.overallHealthColor ?? .yellow
                                    )
                                        .scaleEffect(2)
                                        .frame(width: 125, height: 125, alignment: .center)

                                    Spacer()
                                }
                            } //: VSTACK - Overview

                            /// Overview Data
                            LazyHGrid(rows: [
                                GridItem(.flexible(minimum: 70, maximum: 100)),
                                GridItem(.flexible(minimum: 70, maximum: 100)),
                                GridItem(.flexible(minimum: 70, maximum: 100))
                            ], spacing: 5) {
                                ForEach(0..<5) { index in
                                    let currentSection = SystemDataServiceSection.allCases[index]

                                    StateLinearIconBadge(
                                        title: currentSection,
                                        titleFont: .callout,
                                        label: viewModel.getOverviewLabelFor(currentSection),
                                        lineLevel: viewModel.getOverviewValueFor(currentSection),
                                        lineThickness: 10.0,
                                        textAlignment: .leading
                                    )
                                    .padding(.horizontal)
                                }
                                .frame(minWidth: 100, idealWidth: 200, maxWidth: 250, alignment: .top)
                            } //: LAZYHGRID - Overview data
                            .frame(maxWidth: .infinity, maxHeight: 280, alignment: .center)
                            .padding(.top)

                            Divider()
                                .padding(10)

                            //MARK: - Section Device Information
                            VStack(alignment: .center) {
                                Text("Device Information")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .padding(.top, 5)
                                    .padding(.bottom, 3)

                                VStack {
                                    Text(String(format: "%@ (%@)", viewModel.deviceData?.modelName ?? "Unknown", viewModel.deviceData?.modelIdentifier ?? "Unknown")) // Model Name (Model Identifier)
                                        .foregroundColor(.secondary)

                                    Text(viewModel.deviceData?.deviceSystemVersion ?? "Unknown") // System Version
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 5)
                                } //: VSTACK
                            } //: VSTACK
                            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)
                            .padding(.vertical, 5)

                            //MARK: - Additional Information
                            VStack(alignment: .center, spacing: 0) {
                                Grid(alignment: .top, horizontalSpacing: 25, verticalSpacing: 10) {

                                    GridRow (alignment: .top) {

                                        //MARK: - Section Thermal State
                                        VStack(alignment: .center) {
                                            StateLinearIconBadge(
                                                title: .thermalState,
                                                titleFont: .headline,
                                                label: systemData.thermalState,
                                                lineLevel: ThermalStateGrade.mapFromDisplayValueToLevel(systemData.thermalState),
                                                lineThickness: 7,
                                                textAlignment: .center
                                            )
                                        }

                                        //MARK: - Section Battery
                                        VStack(alignment: .center) {
                                            StateLinearIconBadge(
                                                title: .battery,
                                                titleFont: .headline,
                                                label: "\(String(format: "%.1f", Double(systemData.batteryLevel) * 100)) %",
                                                lineLevel: Double(round(systemData.batteryLevel * 100) / 100) * 100,
                                                lineThickness: 7,
                                                textAlignment: .center
                                            )

                                            Text("\(systemData.batteryState)")
                                                .foregroundStyle(.secondary)
                                                .font(.footnote)
                                                .padding(.top, -10)
                                        }
                                    } //: ROW 1
                                    .padding(.bottom, 5)

                                    GridRow (alignment: .top) {

                                        //MARK: - Section Storage
                                        VStack(alignment: .center) {
                                            StateLinearIconBadge(
                                                title: .storage,
                                                titleFont: .headline,
                                                label: "",
                                                lineLevel: (systemData.storageUsed / systemData.storageCapacity * 100),
                                                lineThickness: 7,
                                                textAlignment: .center
                                            )

                                            VStack {
                                                Text("Total - \(String(format: "%.2f", systemData.storageCapacity)) Gb")
                                                    .foregroundStyle(.secondary)
                                                    .font(.footnote)
                                                Text("Free - \(String(format: "%.2f", systemData.storageAvailable)) Gb")
                                                    .foregroundStyle(.secondary)
                                                    .font(.footnote)
                                            }
                                            .padding(.top, 3)
                                        }

                                        //MARK: - Section RAM Memory
                                        VStack(alignment: .center) {
                                            StateLinearIconBadge(
                                                title: .ramMemory,
                                                titleFont: .headline,
                                                label: "",
                                                lineLevel: systemData.memoryLevel,
                                                lineThickness: 7,
                                                textAlignment: .center
                                            )

                                            VStack {
                                                Text("Total - \(String(format: "%.2f", systemData.memoryCapacity)) Gb")
                                                    .foregroundStyle(.secondary)
                                                    .font(.footnote)
                                                Text("Free - \(String(format: "%.2f", systemData.memoryFree)) Gb")
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
                                            StateLinearIconBadge(
                                                title: .processor,
                                                titleFont: .headline,
                                                label: "",
                                                lineLevel: ((systemData.cpuUsageUser + systemData.cpuUsageSystem) / systemData.storageCapacity * 100),
                                                lineThickness: 7,
                                                textAlignment: .center
                                            )

                                            VStack {
                                                Text("User - \(String(format: "%.2f", systemData.cpuUsageUser))%")
                                                    .foregroundStyle(.secondary)
                                                    .font(.footnote)
                                                Text("System - \(String(format: "%.2f", systemData.cpuUsageSystem))%")
                                                    .foregroundStyle(.secondary)
                                                    .font(.footnote)
                                                Text("Inactive - \(String(format: "%.2f", systemData.cpuUsageInactive))%")
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
                }
            } //: ZSTACK
        } //: NAV
    } //: VIEW
}

//MARK: - PREVIEW
#Preview {
    MainSystemDataView()
        .modelContainer(for: SystemDataProfileDTO.self, inMemory: true)
}
