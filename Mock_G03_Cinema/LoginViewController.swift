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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var isSignIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let srcMain = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
            self.present(srcMain, animated: true)
        } else {
            // No user is signed in.
            resetTextField()
        }
    }
    
    // Process when selector change (login/register)
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        if (isSignIn) {
            titleLabel.text = "Login"
            loginButton.setTitle("Login", for: .normal)
            resetTextField()
        }
        else {
            titleLabel.text = "Register"
            loginButton.setTitle("Register", for: .normal)
            resetTextField()
        }
    }
    
    // Check email format
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // Reset email & password text field
    func resetTextField () {
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            let valid = isValidEmail(testStr: email)
            if (isSignIn) {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Wrong email or password!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: {
                            self.passwordTextField.text?.removeAll()
                        })
                    }
                    else {
                        self.performSegue(withIdentifier: "show account", sender: self)
                    }
                }
            }
            else {
                if (!valid) {
                    let alert = UIAlertController(title: "Error", message: "Wrong email format!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    if (password.characters.count < 6) {
                        let alert = UIAlertController(title: "Error", message: "Password must be at least 6 characters!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Error", message: "Email unavailable!", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: {
                                    self.passwordTextField.text?.removeAll()
                                })
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
        let srcMain = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
        self.present(srcMain, animated: true)
    }
}
