//
//  AuthService.swift
//  souless
//
//  Created by Влад Третьяк on 11/21/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMassage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMassage: String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = authResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
            _ = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                guard metadata != nil else {
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    guard (url?.absoluteString) != nil else {
                        return
                    }
                    let profileImageUrl = url?.absoluteString
                    SetUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!)
                    
                })
            })
        }
        
        func SetUserInformation(profileImageUrl: String, username: String, email: String, uid: String)  {
            let ref = Database.database().reference()
            ref.child("users").child(uid).setValue(["username": username, "email":email, "profileImageUrl" : profileImageUrl])
            onSuccess()
        }
    }
}

