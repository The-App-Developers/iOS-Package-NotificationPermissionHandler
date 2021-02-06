////  NotificationHandler.swift
//
//
//  Created by Connor-Habibi on 2/5/21.
//  Copyright © 2021 -. All rights reserved.
//

import Foundation
import Combine
import UserNotifications


public class NotificationPermissionHandler: NSObject {

    private var cancellable = Set<AnyCancellable>()
    private let deviceState = NotificationDeviceState()
    private let userState = NotificationUserState()
    private(set) public static var share = NotificationPermissionHandler()
    public let latestState = CurrentValueSubject<Bool,Never>(false)

    override private init() {
        super.init()
        setupBinding()
    }
    private func setupBinding() {
        Publishers
            .CombineLatest(
                deviceState.statePublisher.map(\.authorized),
                userState.statePublisher.map(\.authorized))
            .map { $0 && $1 }
            .sink { [weak self] isAuthorize in
                self?.latestState.send(isAuthorize)
                self?.send(state: isAuthorize)
            }
            .store(in: &cancellable)
    }
    private func send(state: Bool) {
        NotificationCenter.default.post(name: .didChangePushNotification, object: state)
    }
    public func setState(isOn: Bool) {
        defer { userState.userAccessed(isAccessed: isOn) }
        deviceState.authorize()
    }

}
