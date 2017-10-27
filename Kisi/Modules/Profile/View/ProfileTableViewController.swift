//
//  ProfileTableViewController.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/26/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import Kingfisher
import UIKit

protocol ProfileTableViewInterface: Interface {}

class ProfileTableViewController: UITableViewController {

    @IBOutlet private var profileImageContainerView: UIView!
    @IBOutlet private var profileImageView: UIImageView!

    var presenter: ProfilePresenterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        profileImageView.kf.setImage(with: URL(string: "https://scontent.fbaq1-1.fna.fbcdn.net/v/t1.0-9/148888_465860022614_2351879_n.jpg?oh=896da2234d5e418c86e99d77c0de5ae8&oe=5A6333A9"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.frame.width / 2
    }
}

extension ProfileTableViewController: StoryBoardIdentifiable {}
