//
//  Friend.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/8/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit

@IBDesignable
class ContactCell: UITableViewCell {

  @IBOutlet weak var contactNameLabel: UILabel!
  @IBOutlet weak var contactEmailLabel: UILabel!
  @IBOutlet weak var contactImageView: UIImageView! {
    didSet {
      contactImageView.layer.masksToBounds = true
      contactImageView.layer.cornerRadius = 22.0
    }
  }
  
  var friend : Friend? {
    didSet {
      configureCell()
    }
  }
  
  private func configureCell() {
    if let friend = friend {
      contactNameLabel.text = friend.firstName + " " + friend.lastName
      contactEmailLabel.text = friend.workEmail
      contactImageView.image = friend.profilePicture
    }
  }
}
