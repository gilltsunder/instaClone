//
//  PostViewCell.swift
//  souless
//
//  Created by Влад Третьяк on 11/26/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = 25
            userImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userName: UILabel! 
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    let test  = #imageLiteral(resourceName: "heartLike_selected")
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: Any) {
        likeButton.setImage(UIImage(named: "heartLike_selected"), for: UIControl.State.normal)
    }
}
