//
//  TableViewCell.swift
//  Solid-ICT Project1
//
//  Created by Buğra Tunçer on 15.08.2019.
//  Copyright © 2019 Buğra Tunçer. All rights reserved.
//

import UIKit
import SwipeCellKit
class MessageCell: SwipeTableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    //  @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
}
