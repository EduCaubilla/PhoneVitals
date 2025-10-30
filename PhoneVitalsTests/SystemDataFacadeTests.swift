//
//  SystemDataFacadeTests.swift
//  PhoneVitalsTests
//
//  Created by Edu Caubilla on 23/10/25.
//

import XCTest
import Combine
@testable import PhoneVitals

// MARK: - System Data Facade Tests

@MainActor
class SystemDataFacadeTests: XCTestCase {

    //MARK: - PROPERTIES

    var sut: SystemDataFacade!

    var mockStorageService: MockStorageInfoService!
    var mockMemoryService: MockMemoryInfoService!
    var mockDeviceService: MockDeviceInfoService!
    var mockCPUService: MockCPUInfoService!
    var cancellables: Set<AnyCancellable>!

    //MARK: - SETUP
    override func setUp() async throws {
        try await super.setUp()

        mockMemoryService = MockMemoryInfoService()
        mockCPUService = MockCPUInfoService()
        mockStorageService = MockStorageInfoService()
        mockDeviceService = MockDeviceInfoService(mockDeviceInfo: DeviceInfo.mock())

        cancellables = []
    }

    //MARK: - TEAR DOWN
    override func tearDown() async throws {
        sut = nil
        mockMemoryService = nil
        mockCPUService = nil
        mockStorageService = nil
        mockDeviceService = nil
        cancellables = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInit_StartsMonitoringServices() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock()
        mockCPUService.mockCPUData = .mock()

        // When
        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        // Wait for async init tasks
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Then
        XCTAssertTrue(mockMemoryService.shouldStartMonitoring)
        XCTAssertTrue(mockCPUService.shouldStartMonitoring)
    }

    // MARK: - System Data Collection Tests

    func testGetAllSystemData_ReturnsCorrectData() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock(
            totalPhysical: 8000,
            usedPhysical: 5000,
            activeMemory: 3000,
            wiredMemory: 2000
        )
        mockCPUService.mockCPUData = .mock(
            systemCpu: 15.0,
            userCpu: 25.5,
            idleCpu: 59.5
        )
        mockStorageService.mockStorageInfo = .mock(
            totalCapacity: 128000,
            availableCapacity: 64000,
            usedCapacity: 64000
        )

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        let result = await sut.getAllSystemData()

        // Then
        XCTAssertEqual(result.memoryCapacity, 8000)
        XCTAssertEqual(result.memoryUsage, 5000) // activeMemory + wiredMemory
        XCTAssertEqual(result.memoryFree, 3000) // totalPhysical - usedPhysical
        XCTAssertEqual(result.cpuUsageUser, 25.5)
        XCTAssertEqual(result.cpuUsageSystem, 15.0)
        XCTAssertEqual(result.cpuUsageInactive, 59.5)
        XCTAssertEqual(result.storageCapacity, 128000)
        XCTAssertEqual(result.storageUsed, 64000)
        XCTAssertEqual(result.storageAvailable, 64000)
    }

    func testGetAllSystemData_HandlesNilMemoryData() async throws {
        // Given
        mockMemoryService.mockMemoryData = nil
        mockCPUService.mockCPUData = .mock()
        mockStorageService.mockStorageInfo = .mock()

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        let result = await sut.getAllSystemData()

        // Then
        XCTAssertEqual(result.memoryCapacity, 0)
        XCTAssertEqual(result.memoryUsage, 0)
        XCTAssertEqual(result.memoryFree, 0)
    }

    func testGetAllSystemData_HandlesNilCPUData() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock()
        mockCPUService.mockCPUData = nil
        mockStorageService.mockStorageInfo = .mock()

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        let result = await sut.getAllSystemData()

        // Then
        XCTAssertEqual(result.cpuUsageUser, 0)
        XCTAssertEqual(result.cpuUsageSystem, 0)
        XCTAssertEqual(result.cpuUsageInactive, 0)
    }

    func testGetAllSystemData_HandlesNilStorageData() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock()
        mockCPUService.mockCPUData = .mock()
        mockStorageService.mockStorageInfo = nil

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        let result = await sut.getAllSystemData()

        // Then
        XCTAssertEqual(result.storageCapacity, 0)
        XCTAssertEqual(result.storageUsed, 0)
        XCTAssertEqual(result.storageAvailable, 0)
    }

    // MARK: - Publisher Tests

    func testSystemDataPublisher_EmitsUpdatedData_WhenMemoryChanges() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock(activeMemory: 1000, wiredMemory: 1000)
        mockCPUService.mockCPUData = .mock()
        mockStorageService.mockStorageInfo = .mock()

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let expectation = XCTestExpectation(description: "System data published")
        var receivedData: SystemDataProfileModel?

        sut.systemDataPublisher
            .compactMap{ $0 }
            .sink { data in
                receivedData = data
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        let updatedMemory = MemoryInfo.mock(activeMemory: 3000, wiredMemory: 3000)
        mockMemoryService.simulateMemoryUpdate(updatedMemory)

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedData)
        XCTAssertEqual(receivedData?.memoryUsage, 6000)
    }

    func testSystemDataPublisher_EmitsUpdatedData_WhenCPUChanges() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock()
        mockCPUService.mockCPUData = .mock(userCpu: 10.0)
        mockStorageService.mockStorageInfo = .mock()

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        let expectation = XCTestExpectation(description: "System data published")
        var receivedData: SystemDataProfileModel?

        sut.systemDataPublisher
            .compactMap{ $0 }
            .sink { data in
                receivedData = data
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        let updatedCPU = CPUInfo.mock(userCpu: 45.0)
        mockCPUService.simulateCPUUpdate(updatedCPU)

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedData)
        XCTAssertEqual(receivedData?.cpuUsageUser, 45.0)
    }

    // MARK: - Device Data Tests

    func testGetAllDeviceData_ReturnsDeviceInfo() async throws {
        // Given
        let expectedDeviceInfo = DeviceInfo.mock()
        mockDeviceService = MockDeviceInfoService(mockDeviceInfo: expectedDeviceInfo)

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        // When
        let result = await sut.getAllDeviceData()

        // Then
        XCTAssertEqual(result, expectedDeviceInfo)
    }

    // MARK: - Deinit Tests

    func testDeinit_StopsMonitoring() async throws {
        // Given
        mockMemoryService.mockMemoryData = .mock()
        mockCPUService.mockCPUData = .mock()

        sut = SystemDataFacade(
            memory: mockMemoryService,
            device: mockDeviceService,
            cpu: mockCPUService,
            storage: mockStorageService
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        // When
        sut = nil

        try await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertTrue(mockMemoryService.shouldStopMonitoring)
        XCTAssertTrue(mockCPUService.shouldStopMonitoring)
    }
}

// MARK: - Integration Tests

@MainActor
class SystemDataFacadeIntegrationTests: XCTestCase {

    func testRealServices_CollectData() async throws {
        // Test real services to verify integration
        let facade = SystemDataFacade()

        let expectation = XCTestExpectation(description: "Real data collected")

        var receivedData: SystemDataProfileModel?
        var cancellables = Set<AnyCancellable>()

        facade.systemDataPublisher
            .compactMap { $0 }
            .first()
            .sink { data in
                receivedData = data
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 5.0)

        XCTAssertNotNil(receivedData)
        XCTAssertGreaterThan(receivedData?.memoryCapacity ?? 0, 0)
    }
}
