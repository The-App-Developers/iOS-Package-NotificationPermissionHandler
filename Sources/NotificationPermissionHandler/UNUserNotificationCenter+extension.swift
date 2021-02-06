////  UNUserNotificationCenter+extension.swift
//
//
//  Created by Connor-Habibi on 2/4/21.
//  Copyright © 2021 -. All rights reserved.
//

import Foundation
import UserNotifications
import Combine


extension UNUserNotificationCenter {

    static let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    func authorize() -> AnyPublisher<Bool,Never> {
        Future { [unowned self] promise in
            requestAuthorization(options: Self.options) {
                (accessGranted, error) in
                promise(.success(accessGranted))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    func getDeviceAuthorizationStatus() -> AnyPublisher<UNAuthorizationStatus, Never> {
      Future { [ unowned self] promise in
        getNotificationSettings { promise(.success($0)) }
      }
      .map(\.authorizationStatus)
      .eraseToAnyPublisher()

    }

}

