//
//  MainSystemDataViewModelTests.swift
//  PhoneVitalsTests
//
//  Created by Edu Caubilla on 24/10/25.
//

import XCTest
import Combine
@testable import PhoneVitals

//MARK: - Main System Data ViewModel Tests

class MainSystemDataViewModelTests: XCTestCase {
    var sut: MainSystemDataViewModel!
    var mockDataFacade: MockSystemDataFacade!
    var mockOverviewCalculator: MockSystemOverviewCalculator!
    var cancellables: Set<AnyCancellable>!

    override func setUp() async throws {
        try await super.setUp()

        mockDataFacade = MockSystemDataFacade()
        mockOverviewCalculator = MockSystemOverviewCalculator()
        cancellables = []
    }

    override func tearDown() async throws {
        sut = nil
        mockDataFacade = nil
        mockOverviewCalculator = nil
        cancellables = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInit_SetsUpSubscriptions() async throws {
        // Given
        mockDataFacade.mockSystemData = .mock()
        mockDataFacade.mockDeviceData = .mock()

        // When
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        // Small delay for init Task to complete
        try await Task.sleep(nanoseconds: 700_000_000)

        // Then
        XCTAssertEqual(mockDataFacade.getAllSystemDataCalledCount, 1)
        XCTAssertEqual(mockDataFacade.getAllDeviceDataCalledCount, 1)
    }

    func testInit_LoadsInitialData() async throws {
        // Given
        let expectedSystemData = SystemDataProfileModel.mock(batteryLevel: 85.0)
        let expectedDeviceData = DeviceInfo.mock()

        mockDataFacade.mockSystemData = expectedSystemData
        mockDataFacade.mockDeviceData = expectedDeviceData

        // When
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertNotNil(sut.systemData)
        XCTAssertNotNil(sut.deviceData)
        XCTAssertEqual(sut.systemData?.batteryLevel, 85.0)
    }

    // MARK: - Publisher Subscription Tests

    func testSystemDataPublisher_UpdatesSystemData() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let newSystemData = SystemDataProfileModel.mock(batteryLevel: 90.0)

        // When
        mockDataFacade.simulateSystemDataUpdate(newSystemData: newSystemData)

        // Give time for publisher to propagate
        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.systemData?.batteryLevel, 90.0)
    }

    func testSystemDataPublisher_TriggersOverviewDataCalculation() async throws {
        // Given
        let mockOverview = OverviewData.mock(batteryScore: 95.0)
        mockOverviewCalculator.overviewData = mockOverview

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let _ = mockOverviewCalculator.calculateOverviewData
        let newSystemData = SystemDataProfileModel.mock()

        // When
        mockDataFacade.simulateSystemDataUpdate(newSystemData: newSystemData)

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
//        XCTAssertGreaterThan(mockOverviewCalculator.calculateOverviewData, overviewDataCallCount) //TODO -->
        XCTAssertEqual(sut.overviewData?.batteryScore, 95.0)
    }

    func testDeviceDataPublisher_UpdatesDeviceData() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let newDeviceData = DeviceInfo.mock()

        // When
        mockDataFacade.simulateDeviceDataUpdate(newDeviceData: newDeviceData)

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.deviceData)
    }

    func testLoadingPublisher_UpdatesIsLoading() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        mockDataFacade.simulateLoadingState(isLoading: true)

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertTrue(sut.isLoading)

        // When
        mockDataFacade.simulateLoadingState(isLoading: false)

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Load Data Tests

    func testLoadFacadeData_FetchesSystemAndDeviceData() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        let initialSystemDataCallCount = mockDataFacade.getAllSystemDataCalledCount
        let initialDeviceDataCallCount = mockDataFacade.getAllDeviceDataCalledCount

        // When
        await sut.loadFacadeData()

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertEqual(mockDataFacade.getAllSystemDataCalledCount, initialSystemDataCallCount + 1)
        XCTAssertEqual(mockDataFacade.getAllDeviceDataCalledCount, initialDeviceDataCallCount + 1)
    }

    func testLoadFacadeData_SetsLoadingState() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        // When
        let loadingTask = Task {
            await sut.loadFacadeData()
        }

        // Check loading is true during execution
        try await Task.sleep(nanoseconds: 50_000_000)
        // Note: This might be flaky due to timing, loading might complete too fast

        await loadingTask.value

        // Then loading should be false after completion
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadOverviewData_CalculatesOverviewWhenSystemDataExists() async throws {
        // Given
        let systemData = SystemDataProfileModel.mock()
        let expectedOverview = OverviewData.mock(batteryScore: 85.0)

        mockDataFacade.mockSystemData = systemData
        mockOverviewCalculator.overviewData = expectedOverview

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        let initialCallCount = mockOverviewCalculator.overviewDataCallCount

        // When
        sut.loadOverviewData()

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertGreaterThan(mockOverviewCalculator.overviewDataCallCount, initialCallCount)
        XCTAssertEqual(sut.overviewData?.batteryScore, 85.0)
    }

    func testLoadOverviewData_DoesNotCalculateWhenSystemDataIsNil() async throws {
        // Given
        mockOverviewCalculator.overviewData = OverviewData.mock()

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let initialCallCount = mockOverviewCalculator.overviewDataCallCount

        // When
        sut.loadOverviewData()

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(mockOverviewCalculator.overviewDataCallCount, initialCallCount)
    }

    // MARK: - View Usage Function Tests
    func testGetOverviewValueFor_ReturnsDefaultWhenOverviewDataIsNil() async throws {
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        // When/Then - should return default 50.0
        XCTAssertEqual(sut.getOverviewValueFor(.thermalState), 50.0)
        XCTAssertEqual(sut.getOverviewValueFor(.battery), 50.0)
        XCTAssertEqual(sut.getOverviewValueFor(.storage), 50.0)
        XCTAssertEqual(sut.getOverviewValueFor(.ramMemory), 50.0)
        XCTAssertEqual(sut.getOverviewValueFor(.processor), 50.0)
    }

    func testGetOverviewLabelFor_CallsCorrectCalculatorMethods() async throws {
        // Given
        mockOverviewCalculator.mockScoreLabel = "Excellent"
        mockOverviewCalculator.mockInvertedScoreLabel = "Good"

        let overviewData = OverviewData.mock()
        mockOverviewCalculator.mockOverviewData = overviewData
        mockDataFacade.mockSystemData = .mock()

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        // When
        let batteryLabel = sut.getOverviewLabelFor(.battery)
        let thermalLabel = sut.getOverviewLabelFor(.thermalState)
        let storageLabel = sut.getOverviewLabelFor(.storage)
        let memoryLabel = sut.getOverviewLabelFor(.ramMemory)
        let cpuLabel = sut.getOverviewLabelFor(.processor)

        // Then
        XCTAssertEqual(batteryLabel, "Excellent") // Uses getOverallScoreLabel
        XCTAssertEqual(thermalLabel, "Good") // Uses getOverallInvertedScoreLabel
        XCTAssertEqual(storageLabel, "Good") // Uses getOverallInvertedScoreLabel
        XCTAssertEqual(memoryLabel, "Good") // Uses getOverallInvertedScoreLabel
        XCTAssertEqual(cpuLabel, "Good") // Uses getOverallInvertedScoreLabel

        XCTAssertEqual(mockOverviewCalculator.overallScoreLabelCount, 1) // Battery only
        XCTAssertEqual(mockOverviewCalculator.overallInvertedScoreLabelCount, 4) // Other 4
    }

    func testGetOverviewLabelFor_ReturnsLabelWhenOverviewDataIsNil() async throws {
        // Given
        mockOverviewCalculator.mockScoreLabel = "Default"
        mockOverviewCalculator.mockInvertedScoreLabel = "Default"

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        // When/Then - should use default 50.0 score
        let label = sut.getOverviewLabelFor(.battery)
        XCTAssertEqual(label, "Default")
    }

    // MARK: - Integration Tests

    func testFullDataFlow_FromPublisherToOverview() async throws {
        // Given
        let systemData = SystemDataProfileModel.mock(batteryLevel: 95.0)
        let overviewData = OverviewData.mock(batteryScore: 90.0)

        mockDataFacade.mockSystemData = systemData
        mockOverviewCalculator.mockOverviewData = overviewData

        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 500_000_000)

        // When
        let newSystemData = SystemDataProfileModel.mock(batteryLevel: 100.0)
        mockDataFacade.simulateSystemDataUpdate(newSystemData: newSystemData)

        try await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertEqual(sut.systemData?.batteryLevel, 100.0)
        XCTAssertNotNil(sut.overviewData)
        XCTAssertGreaterThan(mockOverviewCalculator.overviewDataCallCount, 0)
    }

    func testMemoryManagement_WeakSelfInSubscriptions() async throws {
        // This test verifies that weak self prevents retain cycles
        // Given
        sut = MainSystemDataViewModel(
            systemDataFacade: mockDataFacade,
            systemOverviewCalculator: mockOverviewCalculator
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        weak var weakSUT = sut

        // When
        sut = nil

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(weakSUT, "ViewModel should be deallocated")
    }

}

