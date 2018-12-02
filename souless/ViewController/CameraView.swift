//
//  CameraView.swift
//  souless
//
//  Created by Влад Третьяк on 11/22/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CameraView: UIViewController {
    
    
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var removeButtom: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let tapGusture = UITapGestureRecognizer(target: self, action: #selector(CameraView.handleSelectProfileImageView))
            imageView.addGestureRecognizer(tapGusture)
            imageView.isUserInteractionEnabled = true
        }
    }
    func handlePost(){
        if selectedImage != nil  {
            sharedButton.backgroundColor = .black
            removeButtom.isEnabled = true
            sharedButton.isEnabled = true
        } else {
            sharedButton.backgroundColor = .lightGray
            sharedButton.isEnabled = false
            removeButtom.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePost()
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    var selectedImage : UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sharedButton_pressed(_ sender: Any) {

    
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.1) {
            
            //
            let uid = Auth.auth().currentUser?.uid
           var userName = ""
            var profileImageUrl = ""
    Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any] {
                    userName = (dictionary["username"] as? String)!
                    profileImageUrl = (dictionary["profileImageUrl"] as? String)!
                    
                    
                }
            }, withCancel: nil)
            //
            
            let photoIdString = NSUUID().uuidString
            let StorageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
            StorageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                guard error != nil else {
                    StorageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            ProgressHUD.showError(error?.localizedDescription)
                            return
                        }
                        
                        let photoUrl = url?.absoluteString
                        sendDataToDatabase(photoUrl: photoUrl!, castName: userName, profileImageUrl: profileImageUrl )
                    })
                    return
                }
            })
            func sendDataToDatabase(photoUrl: String, castName: String, profileImageUrl: String ) {
                let ref = Database.database().reference()
                let postsReference = ref.child("posts")
                let newPostId = postsReference.childByAutoId().key
                let newPostReference = postsReference.child(newPostId!)
                newPostReference.setValue(["userName": castName, "photoUrl": photoUrl, "caption":textField.text!, "profileImageUrl":profileImageUrl], withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    } else {
                        ProgressHUD.showSuccess("Done!")
                        self.clean()
                        self.tabBarController?.selectedIndex = 0
                    }
                })
            }
            func testForeUser() {
                

            }
        }
    }
    @IBAction func removeButton(_ sender: Any) {
        clean()
        handlePost()
    }
    func clean() {
        self.textField.text = ""
        self.imageView.image = UIImage(named: "empty_photo")
        self.selectedImage = nil
    }
}
extension CameraView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
}



