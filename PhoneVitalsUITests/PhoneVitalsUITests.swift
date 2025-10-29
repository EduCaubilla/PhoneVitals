//
//  PhoneVitalsUITests.swift
//  PhoneVitalsUITests
//
//  Created by Edu Caubilla on 1/10/25.
//

import XCTest

final class PhoneVitalsUITests: XCTestCase {
    var app: XCUIApplication!
    var timeout: TimeInterval = 2

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    //MARK: - Navigation elements tests
    func testNavigationBarExists() throws {
        let navigationBar = app.navigationBars["Phone Vitals"]
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 4), "Navigation bar should exist")
    }

    func testNavigationBarTitleIsCorrect() throws {
        let navigationBarTitle = app.navigationBars["Phone Vitals"].firstMatch.staticTexts["Phone Vitals"]
        XCTAssertTrue(navigationBarTitle.waitForExistence(timeout: 1), "Navigation bar title should be 'Phone Vitals'")
    }


    func testInfoButtonExists() throws {
        let infoButton = app.images["info.circle"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 1), "Info button should exist in navigation bar")
    }

    func testInfoButtonOpensSheet() throws {
        let infoButton = app.images["info.circle"]
        infoButton.tap()

        // Wait for sheet to appear
        let sheetTitle = app.staticTexts["Overview Data"]
        XCTAssertTrue(sheetTitle.waitForExistence(timeout: 1), "Info sheet should appear")
    }

    // MARK: - Overview Section Tests

    func testOverviewTitleExists() throws {
        // The title "Overview" should be visible
        let overviewTitle = app.staticTexts["Overview"]
        XCTAssertTrue(overviewTitle.waitForExistence(timeout: 2), "Overview title should be visible")
    }

    func testOverallHealthScoreIconDisplayed() throws {
        // The StateRoundIcon should be visible
        let healthIcon = app.otherElements["Overview Main Icon"]

        XCTAssertTrue(healthIcon.waitForExistence(timeout: 1) , "Overall health score icon should be displayed")
    }

    func testOverviewDataBadgesExist() throws {
        sleep(5)
        // There should be 5 StateLinearIconBadge elements for the overview section
        let badges = app.otherElements.matching(identifier: "Overview Icon Badge")
        XCTAssertGreaterThanOrEqual(badges.count, 5, "At least 5 overview badges should exist")
    }

    // MARK: - Device Information Section Tests

    func testDeviceInformationSectionExists() throws {
        sleep (3)

        let deviceInfoTitle = app.staticTexts["Device Information"]
        XCTAssertTrue(deviceInfoTitle.exists, "Device Information section should exist")
    }

    func testDeviceModelDisplayed() throws {
        sleep(5)
        // Scroll to device information section if needed
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        // Check for device model text (format: "Model Name (Model Identifier)")
        let deviceModelText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] '('"))
        XCTAssertTrue(deviceModelText.firstMatch.waitForExistence(timeout: 2), "Device model should be displayed")
    }

    func testSystemVersionDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        // Look for system version text
        let systemVersionExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Version'")).firstMatch.exists
        XCTAssertTrue(systemVersionExists, "System version should be displayed")
    }

    // MARK: - Additional Information Section Tests

    func testThermalStateSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let thermalStateText = app.staticTexts["Thermal State"]
        XCTAssertTrue(thermalStateText.waitForExistence(timeout: 2), "Thermal State section should exist")
    }

    func testBatterySectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let batteryText = app.staticTexts["Battery"]
        XCTAssertTrue(batteryText.waitForExistence(timeout: 2), "Battery section should exist")
    }

    func testBatteryPercentageDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        // Look for percentage symbol
        let percentageText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] '%'"))
        XCTAssertTrue(percentageText.firstMatch.exists, "Battery percentage should be displayed")
    }

    func testBatteryStateDisplayed() throws {
#if targetEnvironment(simulator)
        print("Function testBatteryStateDisplayed() cannot be executed on a simulator. Skipping...")
#else
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        // Battery state should be visible (charging, unplugged, etc.)
        let batteryStateExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Charging' OR label CONTAINS[c] 'Unplugged' OR label CONTAINS[c] 'Full'")).firstMatch.exists
        XCTAssertTrue(batteryStateExists, "Battery state should be displayed")
#endif
    }

    func testStorageSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let storageText = app.staticTexts["Storage"]
        XCTAssertTrue(storageText.waitForExistence(timeout: 2), "Storage section should exist")
    }

    func testStorageInfoDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let freeStorageText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Free' AND label CONTAINS[c] 'GB'"))
        XCTAssertTrue(freeStorageText.firstMatch.exists, "Free storage should be displayed")

        let totalStorageText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Total' AND label CONTAINS[c] 'GB'"))
        XCTAssertTrue(totalStorageText.firstMatch.exists, "Total storage should be displayed")
    }

    func testRAMMemorySectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let ramText = app.staticTexts["RAM Memory"]
        XCTAssertTrue(ramText.waitForExistence(timeout: 2), "RAM Memory section should exist")
    }

    func testRAMInfoDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let freeRAMText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Free' AND label CONTAINS[c] 'GB'"))
        XCTAssertTrue(freeRAMText.firstMatch.exists, "Free RAM should be displayed")

        let usedRAMText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Used' AND label CONTAINS[c] 'GB'"))
        XCTAssertTrue(usedRAMText.firstMatch.exists, "Used RAM should be displayed")
    }

    func testProcessorSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let processorText = app.staticTexts["CPU Processor"]
        XCTAssertTrue(processorText.waitForExistence(timeout: 2), "Processor section should exist")
    }

    func testProcessorInfoDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()

        let userCPUText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'User'"))
        XCTAssertTrue(userCPUText.firstMatch.exists, "User CPU usage should be displayed")

        let systemCPUText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'System'"))
        XCTAssertTrue(systemCPUText.firstMatch.exists, "System CPU usage should be displayed")
    }

    // MARK: - Loading State Tests

//    func testProgressViewAppearsWhenLoading() throws {
//#if targetEnvironment(simulator)
//        print("Function testProgressViewShowsWhenLoading() cannot be executed on a simulator. Skipping...")
//#else
//        let progressView = app.activityIndicators["ProgressView"]
//        let exists = progressView.waitForExistence(timeout: 0.5)
//
//        XCTAssertTrue(exists, "Progress view should show when loading")
//#endif
//    }

    // MARK: - Pull to Refresh Tests

    func testPullToRefresh() throws {
        sleep(3)
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Scroll view should exist")

        // Pull down to refresh
        let start = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let end = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        start.press(forDuration: 0.1, thenDragTo: end)

        // Verify content is still visible after refresh
        let overviewTitle = app.staticTexts["Overview"]
        XCTAssertTrue(overviewTitle.waitForExistence(timeout: 3), "Content should reload after pull to refresh")
    }

    // MARK: - Scroll Tests

    func testScrollToBottom() throws {
        sleep(3)

        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Scroll view should exist")

        // Scroll to bottom
        scrollView.swipeUp()
        scrollView.swipeUp()

        let processorSection = app.staticTexts["CPU Processor"]
        XCTAssertTrue(processorSection.waitForExistence(timeout: 2), "Should be able to scroll to processor section at bottom")
    }

    func testScrollToTop() throws {
        let scrollView = app.scrollViews.firstMatch

        // Scroll down first
        scrollView.swipeUp()
        scrollView.swipeUp()

        // Scroll back to top
        scrollView.swipeDown()
        scrollView.swipeDown()

        let overviewTitle = app.staticTexts["Overview"]
        XCTAssertTrue(overviewTitle.exists, "Should be able to scroll back to overview section at top")
    }
}
