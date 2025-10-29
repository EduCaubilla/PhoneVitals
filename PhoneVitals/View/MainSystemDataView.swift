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
    @State private var viewModel : MainSystemDataViewModel?
    @State private var showOverallInfo: Bool = false

    //MARK: - INITIALIZER
    init(viewModel: MainSystemDataViewModel? = MainSystemDataViewModel()) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.pvDarkGreen)]
        _viewModel = State(wrappedValue: viewModel!)
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
                if viewModel?.isLoading ?? false {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.pvDarkGreen)
                        .accessibilityIdentifier("ProgressView")

                } else {
                    if let viewModel = viewModel,
                       let systemData = viewModel.systemData,
                       let overviewData = viewModel.overviewData,
                       let deviceData = viewModel.deviceData {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                //MARK: - Overview
                                VStack(alignment: .leading, spacing: 0) {
                                    /// Overview Title
                                    Text(Constants.overviewLabel)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, -8)
                                        .padding(.leading, 15)

                                    /// Overview Icon
                                    HStack(alignment: .top, spacing: 5) {
                                        Spacer()

                                        StateRoundIcon(
                                            score: overviewData.overallHealthScore,
                                            label: overviewData.overallHealthLabel,
                                            color: overviewData.overallHealthColor
                                        )
                                        .scaleEffect(2)
                                        .frame(width: 125, height: 125, alignment: .center)
                                        .accessibilityIdentifier("Overview Main Icon")
                                        .padding(.bottom, 10)

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
                                        .accessibilityIdentifier("Overview Icon Badge")
                                    }
                                    .frame(minWidth: 150, idealWidth: 200, maxWidth: 300, alignment: .top)
                                } //: LAZYHGRID - Overview data

                                Divider()
                                    .padding(10)
                                    .padding(.horizontal, 20)

                                //MARK: - Section Device Information
                                VStack(alignment: .center) {
                                    Text(Constants.deviceInformationLabel)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .padding(.top, 5)
                                        .padding(.bottom, 3)

                                    VStack {
                                        Text(deviceData.deviceName) // Device name
                                            .foregroundColor(.secondary)
                                            .padding(.bottom, 5)

                                        HStack {
                                            Text(String(format: Constants.formatDeviceLabel, deviceData.modelName, deviceData.modelIdentifier)) // Model Name (Model Identifier)

                                            Rectangle().frame(width: 1, height: 20)
                                                .foregroundColor(.secondary)

                                            Text(deviceData.deviceSystemVersion) // System Version
                                        }
                                        .foregroundStyle(.secondary)
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
                                                    label: ThermalStateGrade.mapFromOriginStringToGradeStringDisplay(state: systemData.thermalState),
                                                    lineLevel: ThermalStateGrade.mapFromStringToLevel(systemData.thermalState),
                                                    lineThickness: 7,
                                                    textAlignment: .center
                                                )
                                            }

                                            //MARK: - Section Battery
                                            VStack(alignment: .center) {
                                                StateLinearIconBadge(
                                                    title: .battery,
                                                    titleFont: .headline,
                                                    label: "\(systemData.batteryLevel.toStringWhole()) \(Constants.percentageLabel)",
                                                    lineLevel: systemData.batteryLevel,
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
                                                    lineLevel: Tools.percent(partial: systemData.storageUsed, total: systemData.storageCapacity),
                                                    lineThickness: 7,
                                                    textAlignment: .center
                                                )

                                                VStack {
                                                    Text("\(Constants.freeLabel) \(systemData.storageAvailable.toStringTwoDigits()) \(Constants.gigabiteLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)

                                                    Text("\(Constants.totalLabel) \(systemData.storageCapacity.roundCeil().toStringWhole()) \(Constants.gigabiteLabel)")
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
                                                    Text("\(Constants.freeLabel) \(systemData.memoryFree.toStringTwoDigits()) \(Constants.gigabiteLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)

                                                    Text("\(Constants.usedLabel) \(systemData.memoryUsage.toStringTwoDigits()) \(Constants.gigabiteLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)

                                                    Text("\(Constants.totalLabel) \(systemData.memoryCapacity.toStringTwoDigits()) \(Constants.gigabiteLabel)")
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
                                                    lineLevel: Tools.percent(partial: (systemData.cpuUsageUser + systemData.cpuUsageSystem), total: systemData.storageCapacity),
                                                    lineThickness: 7,
                                                    textAlignment: .center
                                                )

                                                VStack {
                                                    Text("\(Constants.userLabel) \(systemData.cpuUsageUser.toStringTwoDigits())\(Constants.percentageLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)
                                                    Text("\(Constants.systemLabel) \(systemData.cpuUsageSystem.toStringTwoDigits())\(Constants.percentageLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)
                                                    Text("\(Constants.inactiveLabel) \(systemData.cpuUsageInactive.toStringTwoDigits())\(Constants.percentageLabel)")
                                                        .foregroundStyle(.secondary)
                                                        .font(.footnote)
                                                }
                                                .padding(.top, 3)
                                            }
                                        } //: ROW 3
                                        .padding(.bottom, 5)
                                    } //: GRID
                                } //: VSTACK
                                .padding(.horizontal, 15)
                                .padding(.vertical, 15)

                            } //: VSTACK MAIN
                            .navigationTitle(Text(Constants.appLabel))
                            .navigationBarTitleDisplayMode(.inline)
                            .padding(.horizontal, 20)
                            .toolbarBackground(.pvLightGreen, for: .navigationBar)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Image(systemName: Constants.infoCircleIcon)
                                        .foregroundStyle(.pvDarkGreen)
                                        .font(.subheadline)
                                        .onTapGesture {
                                            showOverallInfo.toggle()
                                        }
                                }
                            }
                            .sheet(isPresented: $showOverallInfo) {
                                InfoSystemDataView()
                            }
                        } //: SCROLLVIEW
                        .refreshable {
                            await viewModel.loadSystemDeviceData()
                        }
                    }
                }
            } //: ZSTACK
        } //: NAV
    } //: VIEW
}

//MARK: - PREVIEW
#Preview {
    MainSystemDataView()
}
