//
//  LocationManager.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import CoreLocation.CLLocationManager

enum AuthorizationStatus {
    case authorized
    case notAuthorized
    case notDetermined
    case whenInUse

    init(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedAlways: self = .authorized
        case .notDetermined: self = .notDetermined
        case .authorizedWhenInUse: self = .whenInUse
        default: self = .notAuthorized
        }
    }
}

enum LocationManagerError: Error {
    case monitoringDidFail
    case notAuthorized
}

struct BeaconRange {
    let accuracy: Double
    let proximity: LocationManager.Proximity
}

final class LocationManager: NSObject {

    private let locationManager = CLLocationManager()
    private var observers: [LocationManagerObservable] = []
    private let lock = NSLock()
    private let operationQueue = KSOperationQueue()
    private let usage: Usage

    enum Usage {
        case always
        case whenInUse
    }

    enum Proximity: Int {
        case unknown
        case immediate
        case near
        case far
    }

    static var authorizationStatus: AuthorizationStatus {
        return AuthorizationStatus(authorizationStatus: CLLocationManager.authorizationStatus())
    }

    // MARK: Initialization

    init(usage: Usage) {
        self.usage = usage

        super.init()

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    // MARK: Instance methods

    final func addObserver(_ observer: LocationManagerObservable) {
        lock.lock()
        self.observers.append(observer)
        lock.unlock()
    }

    final func isMonitoring(_ lock: Lock) -> Bool {
        return locationManager.monitoredRegions.contains(where: { $0.identifier == String(lock.id) })
    }

    final func removeObserver(_ observer: LocationManagerObservable) {
        lock.lock()
        observers = observers.filter({ $0 !== observer })
        lock.unlock()
    }

    final func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    final func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    final func startMonitoring(_ locks: [Lock]) {
        locks.forEach({ self.startMonitoring($0) })
    }

    final func startMonitoring(_ lock: Lock) {
        let locationPermissionOperation = LocationPermissionOperation(manager: self, usage: usage)
        locationPermissionOperation.operationCompletionBlock { [weak self] isLocationPermissionGranted in
            guard let strongSelf = self else { return }

            if isLocationPermissionGranted {
                let beaconRegion = CLBeaconRegion(proximityUUID: lock.uuid, major: lock.major, minor: lock.minor, identifier: String(lock.id))
                strongSelf.locationManager.startMonitoring(for: beaconRegion)
            } else {
                let observers = strongSelf.currentObservers()
                observers.forEach({ $0.locationManager(strongSelf, didFailWithError: LocationManagerError.notAuthorized) })
            }
        }

        operationQueue.addOperation(locationPermissionOperation)
    }

    final func stopMonitoring() {
        guard let rangedBeaconRegions = locationManager.rangedRegions as? Set<CLBeaconRegion> else { return }

        rangedBeaconRegions.forEach({ self.locationManager.stopRangingBeacons(in: $0) })
    }

    final func stopMonitoring(_ lock: Lock) {
        guard isMonitoring(lock) else { return }

        let beaconRegion = CLBeaconRegion(proximityUUID: lock.uuid, major: lock.major, minor: lock.minor, identifier: String(lock.id))
        locationManager.stopRangingBeacons(in: beaconRegion)
        locationManager.stopMonitoring(for: beaconRegion)
    }

    // MARK: Private methods

    private final func currentObservers() -> [LocationManagerObservable] {
        var observers: [LocationManagerObservable]
        lock.lock()
        observers = self.observers
        lock.unlock()
        return observers
    }
}

extension LocationManager: CLLocationManagerDelegate {

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let authorizationStatus = AuthorizationStatus(authorizationStatus: status)
        let observers = currentObservers()
        observers.forEach({ $0.locationManager(self, didChangeAuthorizationStatus: authorizationStatus) })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let observers = currentObservers()
        observers.forEach({ $0.locationManager(self, didFailWithError: .notAuthorized) })
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let identifier = Int(region.identifier), beacons.isEmpty == false else { return }

        let observers = currentObservers()
        let ranges = beacons.flatMap({ BeaconRange(accuracy: $0.accuracy, proximity: Proximity(rawValue: $0.proximity.rawValue) ?? .unknown) })
        observers.forEach({ $0.locationManager(self, didRangeLocks: ranges, regionIdentifier: identifier) })
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let beaconRegion = region as? CLBeaconRegion else { return }

        locationManager.startRangingBeacons(in: beaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        guard
            /// region
            let region = region,

            /// lock identifier
            let lockIdentifier = Int16(region.identifier) else { return }
        
        let observers = currentObservers()
        observers.forEach({ $0.locationManager(self, monitoringDidFail: lockIdentifier, error: .monitoringDidFail) })
    }
}
