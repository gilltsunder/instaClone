//
//  NewMessage.swift
//  souless
//
//  Created by Влад Третьяк on 12/8/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseDatabase

class NewMessage: UIViewController {
    
    var Users = [UserMessageData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UsersCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UsersCell")
        
        handleUserData()
    }
    
    func handleUserData() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let userNm = dict["username"] as! String
                let userEm = dict["email"] as! String
                let userImg = dict["profileImageUrl"] as! String
                let userId = snapshot.key
                let data = UserMessageData(userNm: userNm, userEm: userEm, userImg: userImg, UserId: userId)
                self.Users.append(data)
                print(self.Users)
                
               self.tableView.reloadData()
                
            }
        }
    }
}

extension NewMessage: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UsersCell = self.tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as? UsersCell else {
            fatalError()
        }
        
        let data = Users[indexPath.row]
        let userImgURL = URL(string: data.userImage!)
        
        cell.username.text = data.userName
        cell.userEmail.text = data.userEmail
        cell.userImage.kf.setImage(with: userImgURL)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.Users[indexPath.row].userName
        let userId = self.Users[indexPath.row].userId
        self.showChatControllerForUser(user: user!, userId: userId)
    }
    
    func showChatControllerForUser(user: String, userId: String) {
        let VC = ChatLogController.makeFromStoryBoard()
        VC.Loguser = user
        VC.userId = userId
        self.navigationController?.pushViewController(VC, animated: true)
    }
}


