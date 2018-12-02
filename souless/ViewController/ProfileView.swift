//
//  ProfileView.swift
//  souless
//
//  Created by Влад Третьяк on 11/26/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher


class ProfileView: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       checkCurrentUser()
    
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/souless-41edd.appspot.com/o/profile_image%2Fvy6JJS2Gknfilt5kaEHL22Jyqqr1?alt=media&token=c711c373-0549-45f0-abc7-1ed166837465")
        img.kf.setImage(with: url)
        
    }
    func checkCurrentUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
            self.navigationItem.title = dictionary["username"] as? String
            }
        }, withCancel: nil)
    }
}
