//
//  TableViewDatasource.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit.UITableView

final class TableViewDatasource <Cell: UITableViewCell, Element>: NSObject, UITableViewDataSource where Cell: ConfigurableCell,
                                                                                                        Cell.Element == Element {

    private weak var delegate: DataSourceDelegate!
    private var items = [Element]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let tableView: UITableView

    var commitEditingStyleClosure: ((UITableView, UITableViewCellEditingStyle, IndexPath) -> Void)?

    // MARK: Initialization

    init(tableView: UITableView, items: [Element], delegate: DataSourceDelegate) {
        self.delegate = delegate
        self.items = items
        self.tableView = tableView

        super.init()

        self.tableView.dataSource = self
    }

    // MARK: Instance mehtods

    final func object(at indexPath: IndexPath) -> Element {
        return items[indexPath.row]
    }

    final func update(_ items: [Element]) {
        self.items = items
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = delegate.datasource(self, cellIdentifierForItemAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cell = cell as? Cell {
            let element = items[indexPath.row]
            cell.configure(for: element)
        }

        return cell
    }
}

extension TableViewDatasource: Datasource {}
