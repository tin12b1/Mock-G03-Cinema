//
//  LoginViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 5/31/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var isSignIn = true
    var isHidePassword = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var btnShowPassword: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            dismiss(animated: true, completion: nil)
        } else {
            // No user is signed in.
            resetTextField()
        }
    }
    
    @IBAction func btnShowPasswordClick(_ sender: Any) {
        if isHidePassword {
            passwordTextField.isSecureTextEntry = false
            isHidePassword = false
        } else {
            passwordTextField.isSecureTextEntry = true
            isHidePassword = true
        }
    }
    // Process when selector change (login/register)
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if (isSignIn) {
            loginButton.setTitle("Login", for: .normal)
            resetTextField()
        }
        else {
            loginButton.setTitle("Register", for: .normal)
            resetTextField()
        }
    }
    
    // Reset email & password text field
    func resetTextField () {
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            let valid = Struct.isValidEmail(testStr: email)
            if (isSignIn) {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        self.displayMyAlertMessage(userMessage: "Wrong email or password!")
                        self.passwordTextField.text?.removeAll()
                    }
                    else {
                        self.performSegue(withIdentifier: "show account", sender: self)
                    }
                }
            }
            else {
                if (!valid) {
                    self.displayMyAlertMessage(userMessage: "Wrong email format!")
                }
                else {
                    if (password.characters.count < 6) {
                        self.displayMyAlertMessage(userMessage: "Password must be at least 6 characters!")
                    }
                    else {
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                self.displayMyAlertMessage(userMessage: "Email Unavailable!")
                                self.passwordTextField.text?.removeAll()
                            }
                            else {
                                self.performSegue(withIdentifier: "add user info", sender: self)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
