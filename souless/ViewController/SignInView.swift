//
//  SignInView.swift
//  souless
//
//  Created by Влад Третьяк on 11/13/18.
//  Copyright © 2018 Влад Третьяк. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class SignInView: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField! {
        didSet {
            emailTextfield.backgroundColor = .black
            emailTextfield.tintColor = .white
            emailTextfield.textColor = .white
            emailTextfield.attributedPlaceholder = NSAttributedString(string: emailTextfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:  UIColor(white: 1.0, alpha: 0.6)])
            let buttonlLayerEmail = CALayer()
            buttonlLayerEmail.frame = CGRect(x: 0, y: 27, width: 380, height: 0.6)
            buttonlLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            emailTextfield.layer.addSublayer(buttonlLayerEmail)
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
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            ProgressHUD.showSuccess("Autologgin: done")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(HomeVC, animated: true, completion: nil)
        }
    }
    
    func handleTextField() {
        emailTextfield.addTarget(self, action: #selector(SignUpView.textFieldDidChenge), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpView.textFieldDidChenge), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChenge() {
        guard let email = emailTextfield.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signInButton.isEnabled = false
                return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton .isEnabled = true
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        view.endEditing(true)
      
        ProgressHUD.showSuccess("Waiting...", interaction: false)
        AuthService.signIn(email: emailTextfield.text!, password: passwordTextField.text!, onSuccess: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(HomeVC, animated: true, completion: nil)
        }, onError: { error in
            ProgressHUD.showError(error)
        })
    }
}
