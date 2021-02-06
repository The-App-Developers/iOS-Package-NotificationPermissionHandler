////  NotificationDeviceState.swift
//
//
//  Created by Connor-Habibi on 2/5/21.
//  Copyright © 2021 -. All rights reserved.
//

import UIKit
import UserNotifications
import Combine


class NotificationDeviceState: NSObject {

    var statePublisher = CurrentValueSubject<NotificationState, Never>(.notDetermined)

    private let notificationCenter = UNUserNotificationCenter.current()
    private var cancellable = Set<AnyCancellable>()
    var refreshPublisher = PassthroughSubject<Void, Never>()

    override init() {
        super.init()
        setupBinding()
        refresh()
    }

    private func setupBinding() {
        NotificationCenter
            .default
            .publisher(
                for: UIApplication.didBecomeActiveNotification,
                object: nil)
            .combineLatest(refreshPublisher)
            .flatMap { [unowned self] _ in
                getAccessLevel()
            }
            .sink { [unowned self] state in
                statePublisher.send(state) }
            .store(in: &cancellable)
    }
    private func getAccessLevel() -> AnyPublisher<NotificationState, Never> {
        notificationCenter.getDeviceAuthorizationStatus()
            .map { NotificationState($0) }
            .eraseToAnyPublisher()
    }
    func refresh() {
        getAccessLevel()
            .sink { [unowned self] state in
                statePublisher.send(state) }
            .store(in: &cancellable)
    }
    func authorize() {
        notificationCenter
            .authorize()
            .map { _ in }
            .sink { [unowned self] in
                refreshPublisher.send() }
            .store(in: &cancellable)
    }

}
