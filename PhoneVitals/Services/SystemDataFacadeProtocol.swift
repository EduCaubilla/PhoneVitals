//
//  SystemDataFacadeProtocol.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 10/10/25.
//

import Foundation
import Combine

protocol SystemDataFacadeProtocol {
    func getAllSystemData() async -> SystemDataProfileModel
    func getAllDeviceData() async -> DeviceInfo

    var systemDataPublisher: AnyPublisher<SystemDataProfileModel?, Never> { get }
    var deviceDataPublisher: AnyPublisher<DeviceInfo, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
}
