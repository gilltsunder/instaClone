//
//  MessageController.swift
//  souless
//
//  Created by Влад Третьяк on 12/8/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class MessageController: UIViewController {
    
    var currentMessage = [currentMessages]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCurrentUser()
        observeMessages()
    }
    
    func observeMessages() {
        Database.database().reference().child("lt").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let text = dict["text"] as! String
                let fromId = dict["fromId"] as! String
                let toId = dict["toId"] as! String
                let timestamp = dict["timestamp"] as! NSNumber
                let test = currentMessages(fromIdd: fromId, textt: text, timestampp: timestamp, toIdd: toId)
                self.currentMessage.append(test)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func checkCurrentUser() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                self.navigationItem.title = dictionary["username"] as? String
            }
        }, withCancel: nil)
    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MessageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellT")
        let message = currentMessage[indexPath.row]
        
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : Any] {
                    cell.textLabel?.text = dict["username"] as? String
                    
                    if let profileUrl = dict["profileImageUrl"] as? String {
                        let test = URL(string: profileUrl)
                        cell.imageView?.kf.setImage(with: test)
                    }
                }
            }, withCancel: nil)
        }
        cell.detailTextLabel?.text = message.text
        
        
//        if let seccond = message.timestamp?.doubleValue {
//            let timeStampDate = NSDate(timeIntervalSince1970: seccond)
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm:ss a"
//            cell.detailTextLabel?.text = dateFormatter.string(from: timeStampDate as Date)
//        }
        
        
        return cell
    }
    
    
}
