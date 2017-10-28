//
//  Protocols.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UserNotifications.UNNotificationRequest
import UIKit.UIViewController

protocol AlertPresentable {}

protocol BackgroundHandler {
    var applicationState: UIApplicationState { get }

    func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (() -> Void)?) -> UIBackgroundTaskIdentifier
    func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier)
}

protocol ConfigurableCell {
    associatedtype Element

    static var identifier: String { get }

    func configure(for element: Element)
}

protocol Datasource: class { }
protocol DataSourceDelegate: class {
    func datasource(_ datasource: Datasource, cellIdentifierForItemAt indexPath: IndexPath) -> String
}

protocol JSONMappeable {
    init?(dictionary: JSONDictionary)
}

protocol Interface: class {}
protocol InteractorInput: class {}
protocol InteractorOutput: class {}

protocol LoadingIndicatorPresentable: class {
    func hideLoadingIndicator()
    func showLoadingIndicator()
}

protocol LocationManagerObservable: class {
    func locationManager(_ manager: LocationManager, didChangeAuthorizationStatus status: AuthorizationStatus)
    func locationManager(_ manager: LocationManager, didFailWithError error: LocationManagerError)
    func locationManager(_ manager: LocationManager, monitoringDidFail lockIdentifier: Int16, error: LocationManagerError)
    func locationManager(_ manager: LocationManager, didRangeLocks ranges: [BeaconRange], regionIdentifier: Int)
}

protocol ObservableOperation {
    func operationDidStart(_ operation: KSOperation)
    func operation(_ operation: KSOperation, didProduceOperation newOperation: Operation)
    func operationDidFinish(_ operation: KSOperation, errors: [Error])
}

protocol OperationCondition {

    static var name: String { get }
    static var isMutuallyExclusive: Bool { get }

    func dependency(for operation: Operation) -> Operation?
    func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void)
}

protocol OperationQueueDelegate: NSObjectProtocol {
    func operationQueue(_ operationQueue: KSOperationQueue, willAddOperation operation: Operation)
    func operationQueue(_ operationQueue: KSOperationQueue, operationDidFinish operation: Operation, withErrors errors: [Error])
}

protocol NotificationPresentable {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
}

protocol Presenter {
    associatedtype PresenterWireframe: Wireframe

    var wireframe: PresenterWireframe? { get set }
}

protocol ResponseSerializer {
    associatedtype SerializedValue

    func serialize(request: URLRequest?,
                   response: HTTPURLResponse?,
                   data: Data, errors: [Error]) -> Result<SerializedValue>
}

protocol StoryBoardIdentifiable {
    static var storyBoardIdentifier: String { get }
}

protocol UserDefaultsStorable {
    func object(forKey defaultName: String) -> Any?
    func removeObject(forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
}

protocol Wireframe: class {
    associatedtype ViewController: UIViewController

    weak var viewController: ViewController? { get set }
}
