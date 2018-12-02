//
//  MessageView.swift
//  souless
//
//  Created by Влад Третьяк on 11/27/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MessageView: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var uMessage = [UserMessageData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            _ = UIView(frame: .zero)
        }
        
        hendleUser()
        
    }
    
    
    func hendleUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let userNm = dict["username"] as! String
                let userEm = dict["email"] as! String
                let userImg = dict["profileImageUrl"] as! String
                let data = UserMessageData(userNm: userNm, userEm: userEm, userImg: userImg)
                self.uMessage.append(data)
                print(self.uMessage)
                
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MessageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MessageCell")
        
        let mmm = uMessage[indexPath.row]
        cell.textLabel?.text = uMessage[indexPath.row].userName
       cell.detailTextLabel?.text = uMessage[indexPath.row].userEmail
        
        let profileImgUrl = URL(string: mmm.userImage!)
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: profileImgUrl!)
                DispatchQueue.main.sync {
                    cell.imageView!.image = UIImage(data: data)
                }
            } catch {
            }}
        
       

        return cell
    }
    
    
}
