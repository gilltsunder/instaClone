//
//  SignUpView.swift
//  souless
//
//  Created by Влад Третьяк on 11/13/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpView: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.backgroundColor = .black
            userNameTextField.tintColor = .white
            userNameTextField.textColor = .white
            userNameTextField.attributedPlaceholder = NSAttributedString(string: userNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:  UIColor(white: 1.0, alpha: 0.6)])
            let buttonlLayerUserName = CALayer()
            buttonlLayerUserName.frame = CGRect(x: 0, y: 27, width: 380, height: 0.6)
            buttonlLayerUserName.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            userNameTextField.layer.addSublayer(buttonlLayerUserName)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.backgroundColor = .black
            emailTextField.tintColor = .white
            emailTextField.textColor = .white
            emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:  UIColor(white: 1.0, alpha: 0.6)])
            let buttonlLayerEmail = CALayer()
            buttonlLayerEmail.frame = CGRect(x: 0, y: 27, width: 380, height: 0.6)
            buttonlLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            emailTextField.layer.addSublayer(buttonlLayerEmail)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.backgroundColor = .black
            passwordTextField.tintColor = .white
            passwordTextField.textColor = .white
            passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:  UIColor(white: 1.0, alpha: 0.6)])
            let buttonlLayerPassword = CALayer()
            buttonlLayerPassword.frame = CGRect(x: 0, y: 27, width: 380, height: 0.6)
            buttonlLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            passwordTextField.layer.addSublayer(buttonlLayerPassword)
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 40
            profileImage.clipsToBounds = true
            let tapGusture = UITapGestureRecognizer(target: self, action: #selector(SignUpView.handleSelectProfileImageView))
            profileImage.addGestureRecognizer(tapGusture)
            profileImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        userNameTextField.addTarget(self, action: #selector(SignUpView.textFieldDidChenge), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpView.textFieldDidChenge), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpView.textFieldDidChenge), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChenge() {
        guard let username = userNameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signUpButton.isEnabled = false
                return
        }
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signUpButton.isEnabled = true
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.showSuccess("Waiting...", interaction: false)
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.1) {
            AuthService.signUp(username: userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Succes")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                self.present(HomeVC, animated: true, completion: nil)
            }, onError: { (errorString) in
                ProgressHUD.showError(errorString)
            })
            
        } else {
            ProgressHUD.showError("Profile image can't be empty")
        }
    }
    
}

extension SignUpView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
