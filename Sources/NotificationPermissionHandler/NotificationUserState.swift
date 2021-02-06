////  NotificationUserState.swift
//
//
//  Created by Connor-Habibi on 2/5/21.
//  Copyright © 2021 -. All rights reserved.
//

import Foundation
import Combine

class NotificationUserState: NSObject {

    var statePublisher = CurrentValueSubject<NotificationState, Never>(.notDetermined)
    private var cancellable = Set<AnyCancellable>()
    private let userDefaultNoticationKey = "USERDEFAULT_NOTIFICATION"
    private var userNotification: Bool? {
        get {
            UserDefaults.standard.synchronize()
            return UserDefaults.standard.value(forKey: userDefaultNoticationKey) as? Bool
        } set {
            DispatchQueue.main.async { [self] in
                UserDefaults.standard.set(newValue, forKey: userDefaultNoticationKey)
                UserDefaults.standard.synchronize()
            }
        }
    }

    override init() {
        super.init()
        setupBinding()
        refresh()
    }

    func refresh() {
        getAccessLevel()
            .sink { [unowned self] state in
                statePublisher.send(state) }
            .store(in: &cancellable)
    }
    private func setupBinding() {
        NotificationCenter
            .default
            .publisher(
                for: UserDefaults.didChangeNotification,
                object: nil)
            .flatMap { [unowned self] _ in
                getAccessLevel()
            }
            .sink { [unowned self] state in
                statePublisher.send(state) }
            .store(in: &cancellable)
    }

    private func getAccessLevel() -> AnyPublisher<NotificationState, Never> {
            Just(userNotification)
            .map { NotificationState($0) }
            .eraseToAnyPublisher()
    }
    func userAccessed(isAccessed: Bool) {
        userNotification = isAccessed
    }

}
