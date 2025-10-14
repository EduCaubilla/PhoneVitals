//
//  MainSystemDataViewModel.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import Foundation
import Combine


class MainSystemDataViewModel: ObservableObject {
    //MARK: - PROPERTIES
    @Published var deviceData: DeviceInfo?
    @Published var systemData: SystemDataProfileModel?
    @Published var isLoading: Bool = false

    private let systemDataFacade: any SystemDataFacadeProtocol

    private var cancellables: Set<AnyCancellable> = []

    //MARK: - INITIALIZER
    init(systemDataFacade: any SystemDataFacadeProtocol = SystemDataFacade()) {
        self.systemDataFacade = systemDataFacade

        setupSubscriptions()
        loadFacadeData()
    }

    //MARK: - FUNCTIONS
    func setupSubscriptions() {
        //Subscribe to system data
        systemDataFacade.systemDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] systemData in
                self?.systemData = systemData
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

    func loadFacadeData() {
        Task { @MainActor in
            self.isLoading = true
            self.systemData =  await self.systemDataFacade.getAllSystemData()
            self.deviceData = await self.systemDataFacade.getAllDeviceData()
            self.isLoading = false
        }
    }
}
