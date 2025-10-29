//
//  MockSystemDataFacade.swift
//  PhoneVitalsTests
//
//  Created by Edu Caubilla on 24/10/25.
//

import XCTest
import Combine
@testable import PhoneVitals


class MockSystemDataFacade: SystemDataFacadeProtocol {
    //MARK: - PROPERTIES
    var mockSystemData : SystemDataProfileModel?
    var mockDeviceData : DeviceInfo?
    var mockIsLoading : Bool = false

    private let systemDataSubject = PassthroughSubject<SystemDataProfileModel?, Never>()
    private let deviceDataSubject = PassthroughSubject<DeviceInfo, Never>()

    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    //MARK: - Publishers for the viewModel to subscribe to
    var systemDataPublisher : AnyPublisher<SystemDataProfileModel?, Never> {
        systemDataSubject.eraseToAnyPublisher()
    }

    var deviceDataPublisher : AnyPublisher<DeviceInfo, Never> {
        deviceDataSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }

    var getAllSystemDataCalledCount: Int = 0
    var getAllDeviceDataCalledCount: Int = 0

    //MARK: - FUNCTIONS
    func getAllSystemData() async -> SystemDataProfileModel {
        getAllSystemDataCalledCount += 1
        dump(mockSystemData)
        return mockSystemData ?? SystemDataProfileModel.mock()
    }

    func getAllDeviceData() async -> DeviceInfo {
        getAllDeviceDataCalledCount += 1
        return mockDeviceData ?? DeviceInfo.mock()
    }

    func simulateSystemDataUpdate(newSystemData: SystemDataProfileModel?) {
        self.mockSystemData = newSystemData
        systemDataSubject.send(newSystemData)
    }

    func simulateDeviceDataUpdate(newDeviceData: DeviceInfo) {
        self.mockDeviceData = newDeviceData
        deviceDataSubject.send(newDeviceData)
    }
    
    func simulateLoadingState(isLoading: Bool) {
        self.mockIsLoading = isLoading
        loadingSubject.send(isLoading)
    }
}
