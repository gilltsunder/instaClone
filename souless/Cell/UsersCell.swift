//
//  UsersCell.swift
//  souless
//
//  Created by Влад Третьяк on 12/8/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.clipsToBounds = true
            userImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var username: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
