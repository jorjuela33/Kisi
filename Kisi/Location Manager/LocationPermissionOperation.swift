//
//  LocationPermissionOperation.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import CoreLocation.CLLocationManager

final class LocationPermissionOperation: KSOperation {

    private var isLocationPermissionGranted = false
    private let manager: LocationManager
    private let operationQueue = OperationQueue()
    private let usage: LocationManager.Usage

    // MARK: Initialization

    init(manager: LocationManager, usage: LocationManager.Usage) {
        self.manager = manager
        self.usage = usage

        super.init()

        addCondition(AlertPresentation())
        operationQueue.isSuspended = true
        manager.addObserver(self)
        name = "Location Permission Operation"
    }

    // MARK: Instance methods

    @discardableResult
    final func operationCompletionBlock(_ completionBlock: @escaping (Bool) -> Void) -> Self {
        operationQueue.addOperation {
            DispatchQueue.main.async {
                completionBlock(self.isLocationPermissionGranted)
            }
        }

        return self
    }

    // MARK: Overrided methods

    override func execute() {
        switch (LocationManager.authorizationStatus, usage) {
        case (.notDetermined, _), (.whenInUse, .always):
            DispatchQueue.main.async {
                self.requestPermission()
            }

        case (.notAuthorized, _):
            isLocationPermissionGranted = false

        default:
            isLocationPermissionGranted = true
            finish()
        }
    }

    override func finished(_ errors: [Error]) {
        operationQueue.isSuspended = false
        manager.removeObserver(self)
    }

    // MARK: Private methods

    private final func requestPermission() {
        let key: String

        switch usage {
        case .whenInUse:
            key = "NSLocationWhenInUseUsageDescription"
            manager.requestWhenInUseAuthorization()

        case .always:
            key = "NSLocationAlwaysAndWhenInUseUsageDescription"
            manager.requestAlwaysAuthorization()
        }

        assert(Bundle.main.object(forInfoDictionaryKey: key) != nil, "Requesting location permission requires the \(key) key in your Info.plist")
    }
}

extension LocationPermissionOperation: LocationManagerObservable {

    // MARK: LocationManagerObservable

    func locationManager(_ manager: LocationManager, didChangeAuthorizationStatus status: AuthorizationStatus) {
        guard status != .notDetermined else { return }

        isLocationPermissionGranted = status == .authorized
        finish()
    }

    func locationManager(_ manager: LocationManager, didFailWithError error: LocationManagerError) { /* NO OP */ }
    func locationManager(_ manager: LocationManager, didRangeLocksInProximities proximities: [LocationManager.LockProximity], regionIdentifier: Int) {
    }
    func locationManager(_ manager: LocationManager, monitoringDidFail lockIdentifier: Int16, error: LocationManagerError) { /* NO OP */ }
}
