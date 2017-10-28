//
//  LocksInteractor.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Foundation

protocol LocksInteractorInput: InteractorInput {
    func getLocks()
}

protocol LocksInteractorOutput: InteractorOutput {
    func didFailFetchingLocks(_ errors: [Error])
    func didFinishFetchingLocks(_ locks: [LockDisplayItem])
    func didFoundLock(_ identifier: Int)
    func locationPermissionNotAuthorized()
    func locationManagerDidFail(withError error: LocationManagerError)
}

private let beaconFilter: Double = 0.5

class LocksInteractor {

    private let locationManager: LocationManager
    private let operationQueue: NetworkingOperationQueue
    private var displayItems: [LockDisplayItem] = []

    weak var presenter: LocksInteractorOutput?

    // MARK: Initialization

    init(locationManager: LocationManager, operationQueue: NetworkingOperationQueue) {
        self.locationManager = locationManager
        self.operationQueue = operationQueue
        locationManager.addObserver(self)
    }
}

extension LocksInteractor: LocksInteractorInput {

    // MARK: LockInteractorInput

    func getLocks() {
        let getLocksOperation = GetLocksOperation()
        getLocksOperation.operationCompletionBlock { [weak self] locks, errors in
            guard errors.isEmpty else {
                self?.presenter?.didFailFetchingLocks(errors)
                return
            }

            let displayItems = locks.flatMap({ LockDisplayItem(id: $0.id, description: $0.description, name: $0.name, uuid: $0.uuid.uuidString) })
            self?.locationManager.startMonitoring(locks)
            self?.presenter?.didFinishFetchingLocks(displayItems)
            self?.displayItems = displayItems
        }

        operationQueue.addOperation(getLocksOperation)
    }
}

extension LocksInteractor: LocationManagerObservable {

    // MARK: LocationManagerObservable

    func locationManager(_ manager: LocationManager, didChangeAuthorizationStatus status: AuthorizationStatus) {
        guard status == .notAuthorized else { return }

        presenter?.locationPermissionNotAuthorized()
    }

    func locationManager(_ manager: LocationManager, didFailWithError error: LocationManagerError) {
        presenter?.locationManagerDidFail(withError: error)
    }

    func locationManager(_ manager: LocationManager, didRangeLocks ranges: [BeaconRange], regionIdentifier: Int) {
        for range in ranges {
            guard range.accuracy <= beaconFilter else { continue }

            locationManager.stopMonitoring()
            presenter?.didFoundLock(regionIdentifier)
            break
        }
    }

    func locationManager(_ manager: LocationManager, monitoringDidFail lockIdentifier: Int16, error: LocationManagerError) { /* NO OP */ }
}
