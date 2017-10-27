//
//  LocksTableViewController.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

protocol LocksTableViewControllerInterface: class {
    func didFinishFechingLocks(_ locks: [LockDisplayItem])
    func showErrorMessage(_ message: String)
}

class LocksTableViewController: UITableViewController {

    private var datasource: TableViewDatasource<LockTableViewCell, LockDisplayItem>?

    var presenter: LocksPresenterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Locks"
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.contentOffset = CGPoint(x: 0, y: -(refreshControl?.frame.height ?? 0))
        refreshControl?.beginRefreshing()

        datasource = TableViewDatasource(tableView: tableView, items: [], delegate: self)
        presenter?.getLocks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions

    @IBAction private func refresh(_ sender: UIRefreshControl) {
        presenter?.getLocks()
    }
}

extension LocksTableViewController: LocksTableViewControllerInterface {

    // MARK: UnlockViewControllerInterface

    func didFinishFechingLocks(_ locks: [LockDisplayItem]) {
        refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.05)
        datasource?.update(locks)
    }

    func showErrorMessage(_ message: String) {
        refreshControl?.endRefreshing()
        showMessage(message)
    }
}

extension LocksTableViewController: DataSourceDelegate {

    // MARK: DataSourceDelegate

    func datasource(_ datasource: Datasource, cellIdentifierForItemAt indexPath: IndexPath) -> String {
        return LockTableViewCell.identifier
    }
}

extension LocksTableViewController: AlertPresentable, LoadingIndicatorPresentable, StoryBoardIdentifiable {}
