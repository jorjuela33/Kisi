//
//  LockTableViewCell.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

class LockTableViewCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var uuidLabel: UILabel!

    static var identifier: String = "LockTableViewCellIdentifier"
}

extension LockTableViewCell: ConfigurableCell {

    // MARK: ConfigurableCell

    func configure(for lockDisplayItem: LockDisplayItem) {
        nameLabel.text = lockDisplayItem.name
        uuidLabel.text = lockDisplayItem.uuid
    }
}
