//
//  ChatLogController.swift
//  souless
//
//  Created by Влад Третьяк on 12/7/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class ChatLogController: UIViewController {
    
    var Loguser : String? {
        didSet{
            navigationItem.title = Loguser
        }
    }
    var userId : String?
    
 
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
    }
    
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = userId
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text" : textView.text!, "toId": toId!, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
        
    }
    

}


extension ChatLogController {
    static func makeFromStoryBoard() -> ChatLogController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let NewMessage = storyboard.instantiateViewController(withIdentifier: "ChatLogController")
        return NewMessage as! ChatLogController
    }
}
