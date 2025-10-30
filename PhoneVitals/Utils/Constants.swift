//
//  Constants.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 21/10/25.
//

import Foundation
import SwiftUI

struct Constants {

    static let appLabel: String = "Phone Vitals"

    static let overviewLabel: String = "Overview"
    static let informationLabel: String = "Information"
    static let deviceInformationLabel: String = "Device Information"

    static let overviewDataLabel: String = "Overview Data"
    static let informationDataLabel: String = "Information Data"

    static let progressViewAccessId: String = "ProgressView"
    static let overviewMainAccessId: String = "OverviewMainIcon"
    static let overviewIconAccessId: String = "OverviewIconBadge"

    static let freeLabel: String = "Free - "
    static let usedLabel: String = "Used - "
    static let totalLabel: String = "Total - "
    static let userLabel: String = "User - "
    static let systemLabel: String = "System - "
    static let inactiveLabel: String = "Inactive - "
    static let gigabiteLabel: String = "Gb"
    static let percentageLabel: String = "%"
    static let formatDeviceLabel: String = "%@ (%@)"

    static let infoCircleIcon: String = "info.circle"

    static let infoExampleDouble: Double = 50.0
    static let infoExampleColor: Color = .darkYellow
    static let infoExampleLabelFair: String = "Fair"
    static let infoExampleLabelGood: String = "Good"

    static let overviewDescription = try! AttributedString(markdown: "**Overview** gives a quick summary of the system data. The **main graphic icon** shows the overall health of the system based on data from all the aspects monitored of the system. The **evaluation** inside the icon provides a brief description of the system status and it's calculated based on the data collected from all the monitored aspects with different weights for each aspect depending on its importance. Current weights are as follows: ")
    static let overviewDescriptionListThermal = String("- 30% Thermal State")
    static let overviewDescriptionListBattery = String("- 15% Battery State")
    static let overviewDescriptionListStorage = String("- 15% Storage State")
    static let overviewDescriptionListMemory = String("- 20% Memory State")
    static let overviewDescriptionListProcessor = String("- 20% Processor State")
    static let overviewSections = try! AttributedString(markdown: "The **parameters** below the icon provide more detailed information about the system status. Each one has its name, a visual representation and a short evaluation of its current state to help identify any potential issues at a glance. Thermal State, Battery and Storage have an algorithm that uses several data provided by the system and other factors to calculate the current state of the section.")
    static let overviewThermal = try! AttributedString(markdown: "**Thermal State** is a parameter given by the system that shows the general temperature and it has four levels: nominal, fair, serious and critical. The system considers the temperature of the CPU, GPU, memory and other internal components. Phone Vitals gives an amount over hundred to each value as follows: nominal (12.5), fair (35.0), serious (65.0) and critical (87.5) so its more easy to understand.")
    static let overviewBattery = try! AttributedString(markdown: "**Battery** is a computed value representing the current state of the battery. Apple recommends keeping the charge between 20-80% and avoid keeping the battery at 100% or 0% for long periods. Phone Vitals, according to Apple guidelines, gives a value from charge percentage as follows: for 0%-20% is 20, 20%-40% is 70, 40%-80% is 95, 80%-100% is 80. Also there's a factor that depends if the device is unplugged and if battery low mode is enabled. You can check for more information about [battery care](https://support.apple.com/en-us/101575).")
    static let overviewStorage = try! AttributedString(markdown: "**Storage** is a value that does not correspond to the actual percentage of storage available. According to experts, the storage available should be more than 20%, between 10% and 15% is fine, between 5% and 10% is risky, between 3% and 5% is very risky and less than 3% is critical as it can cause app crashes, failed updates, temporary file corruption and other performance issues. Phone Vitals has assigned values according to these ranges adding different values to higher levels. You can check for more information about [managing storage](https://support.apple.com/en-us/108429).")

    static let deviceInformation = try! AttributedString(markdown: "**Device information** section provides detailed information about the device itself. It includes the device name, device model, model identifier and current system version. This data is merely for informational purposes and does not affect the evaluation scores.")
    static let thermalStateSection = try! AttributedString(markdown: "**Thermal State** section shows an evaluation of the internal temperature of the device and has four parameters given by the system that Phone Vitals turns into level and a short text evaluations (Very good, Good, Bad & Critical) based on the values detailed above in the overview section.")
    static let batteryStateSection = try! AttributedString(markdown: "**Battery** refers to the current state of the battery and its percentage of charge. Also shows the state of charging or discharging.")
    static let storageStateSection = try! AttributedString(markdown: "**Storage** shows the current total capacity and free capacity available to use in the device.")
    static let ramMemoryStateSection = try! AttributedString(markdown: "**RAM memory** is the short-term storage that the device uses to store data and applications that are currently running and it's important for the performance of the system. The graph shows the free, used and total space of the RAM memory.")
    static let CPUProcessorSection = try! AttributedString(markdown: "**CPU processor** is the **C**entral **P**rocessing **U**nit of the device and handles all the computing tasks that make apps work and its usage percentage directly impacts the general performance of the system. The graph shows the used percentage by user and by system, and the inactive part of the CPU usage.")

}
