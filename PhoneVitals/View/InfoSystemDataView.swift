//
//  InfoSystemDataView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 21/10/25.
//

import SwiftUI

struct InfoSystemDataView: View {

    @Environment(\.dismiss) private var dismiss
    private let currentPlatform = UIDevice.current.userInterfaceIdiom

    //MARK: - BODY
    var body: some View {
        ZStack {
            /// Background
            LinearGradient(
                gradient: Gradient(colors: [.pvLightGreen, .pvWhite]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ///Content
            ScrollView{
                //MARK: - OVERVIEW EXPLAINED
                VStack(alignment: .center, spacing: 8){
                    HStack {
                        Text(Constants.overviewDataLabel)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        if currentPlatform == .pad {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.pvDarkGreen)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    }

                    HStack(alignment: .top, spacing: 10) {
                        Spacer()

                        StateRoundIcon(
                            score: Constants.infoExampleDouble,
                            label: Constants.infoExampleLabelFair,
                            color: Constants.infoExampleColor
                        )
                        .scaleEffect(1.5)
                        .padding(20)

                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(Constants.overviewDescription)
                        Text(Constants.overviewDescriptionListThermal)
                        Text(Constants.overviewDescriptionListBattery)
                        Text(Constants.overviewDescriptionListStorage)
                        Text(Constants.overviewDescriptionListMemory)
                        Text(Constants.overviewDescriptionListProcessor)
                    }
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 5)

                    HStack(alignment: .top, spacing: 10) {
                        StateLinearIconBadge(
                            title: SystemDataServiceSection.example,
                            titleFont: .callout,
                            label: Constants.infoExampleLabelGood,
                            lineLevel: Constants.infoExampleDouble,
                            lineThickness: 10.0,
                            textAlignment: .leading
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal,30)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text(Constants.overviewSections)
                        Text(Constants.overviewThermal)
                        Text(Constants.overviewBattery)
                        Text(Constants.overviewStorage)
                    }
                    .foregroundStyle(.secondary)

                    //MARK: - Information
                    Text(Constants.informationDataLabel)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(Constants.deviceInformation)
                        Text(Constants.thermalStateSection)
                        Text(Constants.batteryStateSection)
                        Text(Constants.storageStateSection)
                        Text(Constants.ramMemoryStateSection)
                        Text(Constants.CPUProcessorSection)
                    }
                    .foregroundStyle(.secondary)

                } //: VSTACK Content
                .padding(
                    currentPlatform == .pad ? EdgeInsets(top: 20, leading: 30, bottom: 10, trailing: 30) : EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20)
                )
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    InfoSystemDataView()
}
