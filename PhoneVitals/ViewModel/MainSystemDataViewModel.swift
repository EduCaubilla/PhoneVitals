//
//  MainSystemDataViewModel.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import Combine
import SwiftUI

class MainSystemDataViewModel: ObservableObject {
    //MARK: - PROPERTIES
    @Published private(set) var deviceData: DeviceInfo?
    @Published private(set) var systemData: SystemDataProfileModel?
    @Published private(set) var overviewData: OverviewData?
    @Published var isLoading: Bool = false

    private let systemDataFacade: any SystemDataFacadeProtocol
    private let systemOverviewCalculator: SystemOverviewCalculator

    private var cancellables: Set<AnyCancellable> = []

    //MARK: - INITIALIZER
    init(systemDataFacade: any SystemDataFacadeProtocol = SystemDataFacade(),
        systemOverviewCalculator: SystemOverviewCalculator = SystemOverviewCalculator()) {
        self.systemDataFacade = systemDataFacade
        self.systemOverviewCalculator = systemOverviewCalculator

        setupSubscriptions()

        Task { @MainActor in
            self.isLoading = true
            await loadFacadeData()
            loadOverviewData()
            self.isLoading = false
        }
    }

    //MARK: - FUNCTIONS

    //MARK: - Config Observables
    func setupSubscriptions() {
        //Subscribe to system data
        systemDataFacade.systemDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] systemData in
                self?.systemData = systemData
                self?.loadOverviewData()
            }
            .store(in: &cancellables)

        //Subscribe to device data
        systemDataFacade.deviceDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deviceData in
                self?.deviceData = deviceData
            }
            .store(in: &cancellables)

        //Subscribe to loading data
        systemDataFacade.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
    }

    //MARK: - Load data
    func loadFacadeData() async {
        Task { @MainActor in
            isLoading = true
            self.systemData =  await self.systemDataFacade.getAllSystemData()
            self.deviceData = await self.systemDataFacade.getAllDeviceData()
            isLoading = false
        }
    }

    func loadOverviewData() {
        Task { @MainActor in
            guard let systemData = systemData else { return }
            overviewData = systemOverviewCalculator.calculateOverviewData(profile: systemData)
        }
    }

    //MARK: - View usage functions
    func getOverviewValueFor(_ section: SystemDataServiceSection) -> Double {
        switch section {
            case .thermalState:
                return overviewData?.thermalScore ?? 50.0
            case .battery:
                return overviewData?.batteryScore ?? 50.0
            case .storage:
                return overviewData?.storageScore ?? 50.0
            case .ramMemory:
                return overviewData?.memoryScore ?? 50.0
            case .processor:
                return overviewData?.cpuScore ?? 50.0
        }
    }

    func getOverviewLabelFor(_ section: SystemDataServiceSection) -> String {
        switch section {
            case .thermalState:
                return systemOverviewCalculator.getOverallScoreLabel(score: overviewData?.thermalScore ?? 50.0)
            case .battery:
                return systemOverviewCalculator.getOverallScoreLabel(score: overviewData?.batteryScore ?? 50.0)
            case .storage:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.storageScore ?? 50.0)
            case .ramMemory:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.memoryScore ?? 50.0)
            case .processor:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.cpuScore ?? 50.0)
        }
    }
    
}
