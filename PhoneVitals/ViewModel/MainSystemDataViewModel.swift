//
//  MainSystemDataViewModel.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

@Observable
class MainSystemDataViewModel {
    //MARK: - PROPERTIES
    private(set) var deviceData: DeviceInfo?
    private(set) var systemData: SystemDataProfileModel?
    private(set) var overviewData: OverviewData?
    var isLoading: Bool = true

    private let systemDataFacade: any SystemDataFacadeProtocol
//    private let systemDataStore: SystemDataStoreProtocol

    private let systemOverviewCalculator: SystemOverviewCalculator

    private var cancellables: Set<AnyCancellable> = []

    //MARK: - INITIALIZER
    init(systemDataFacade: any SystemDataFacadeProtocol = SystemDataFacade(),
//         systemDataStore: SystemDataStoreProtocol,
         systemOverviewCalculator: SystemOverviewCalculator = SystemOverviewCalculator()) {

        self.systemDataFacade = systemDataFacade
//        self.systemDataStore = systemDataStore
        self.systemOverviewCalculator = systemOverviewCalculator

        self.isLoading = true

        setupSubscriptions()

        Task {
            await loadSystemDeviceData()
//            await saveProfile()
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
            .sink { [weak self] loading in
                self?.isLoading = loading
            }
            .store(in: &cancellables)
    }

    //MARK: - Load data
    @MainActor
    func loadSystemDeviceData() async {
        isLoading = true

        try? await Task.sleep(nanoseconds: 300_000_000)

        await loadFacadeData()
        loadOverviewData()

        isLoading = false
    }

    func loadFacadeData() async {
        self.systemData =  await self.systemDataFacade.getAllSystemData()
        self.deviceData = await self.systemDataFacade.getAllDeviceData()
    }

    func loadOverviewData() {
        guard let systemData = systemData else { return }
        overviewData = systemOverviewCalculator.calculateOverviewData(profile: systemData)
    }

    //MARK: - Save data
    //Commented so it can be added on next phase
//    func saveProfile() async {
//        guard let systemData = systemData else { return }
//        do {
//            let profileSaved = try systemDataStore.save(systemData)
//            if profileSaved {
//                print("Profile saved successfully")
//            } else {
//                print("Profile not saved")
//            }
//        } catch {
//            print("There was an error trying to save the profile \(String(describing: systemData.id)) : \(error.localizedDescription)")
//        }
//    }

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
            case .example:
                return 50.0
        }
    }

    func getOverviewLabelFor(_ section: SystemDataServiceSection) -> String {
        switch section {
            case .thermalState:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.thermalScore ?? 50.0)
            case .battery:
                return systemOverviewCalculator.getOverallScoreLabel(score: overviewData?.batteryScore ?? 50.0)
            case .storage:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.storageScore ?? 50.0)
            case .ramMemory:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.memoryScore ?? 50.0)
            case .processor:
                return systemOverviewCalculator.getOverallInvertedScoreLabel(score: overviewData?.cpuScore ?? 50.0)
            case .example:
                return "Example"
        }
    }
    
}
