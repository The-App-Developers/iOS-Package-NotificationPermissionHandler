////  NotificationState.swift
//
//
//  Created by Connor-Habibi on 2/5/21.
//  Copyright © 2021 -. All rights reserved.
//

import Foundation
import NotificationCenter


enum NotificationState {

    case notDetermined, denied, authorized

    var authorized: Bool { self == .authorized }

    init(_ authorizationStatus: UNAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            self = .notDetermined
        case .authorized:
            self = .authorized
        case .denied, .provisional, .ephemeral:
            self = .denied
        @unknown default:
            self = .denied
        }
    }

    init(_ pushNotificationGranted: Bool?) {
        switch pushNotificationGranted {
        case .none:
            self = .notDetermined
        case .some(false):
            self = .denied
        case .some(true):
            self = .authorized
        }
    }

}
