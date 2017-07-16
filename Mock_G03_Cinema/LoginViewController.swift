//
//  LoginViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 5/31/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Global variables
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    var isSignIn = true
    var isHidePassword = true
    var keyboardIsShow = false
    let userMessage = UserMessage.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dismiss and hide/show keyboard
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (Auth.auth().currentUser != nil) {
            // If user is signed in, dismiss this view
            dismiss(animated: true, completion: nil)
        } else {
            // If no user is signed in, reset username and password textfields
            resetTextField()
        }
    }
    
    // Show/hide password
    @IBAction func btnShowPasswordClick(_ sender: Any) {
        if (isHidePassword) {
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
    
    // Process when user click login button
    @IBAction func loginButtonClick(_ sender: Any) {
        // Check if user didn't input email, password textfields
        if (emailTextField.text == "" || passwordTextField.text == "") {
            self.displayMyAlertMessage(userMessage: userMessage.missingInput)
        }
        else {
            // Check internet connection
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let email = emailTextField.text
                let password = passwordTextField.text
                let valid = Struct.isValidEmail(testStr: email!)
                if (isSignIn) {
                    // Validate login
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        if error != nil {
                            self.displayMyAlertMessage(userMessage: self.userMessage.wrongLogin)
                            self.passwordTextField.text?.removeAll()
                        }
                        else {
                            self.performSegue(withIdentifier: "show account", sender: self)
                        }
                    }
                }
                else {
                    // Validate register
                    if (!valid) {
                        // Wrong email format
                        self.displayMyAlertMessage(userMessage: userMessage.invalidEmailFormat)
                    }
                    else {
                        // Password too short
                        if ((password?.characters.count)! < 6) {
                            self.displayMyAlertMessage(userMessage: userMessage.passwordShort)
                        }
                        else {
                            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                                if error != nil {
                                    // Email unavailable
                                    self.displayMyAlertMessage(userMessage: self.userMessage.emailUsed)
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
    }
    
    // Process when user click Back button
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Method
    
    // Reset email & password text field
    func resetTextField () {
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
    }
    
    // Display alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Hide/Show
    
    // Dismiss keyboard
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    // Process when show keyboard
    func keyboardWillShow(notification:NSNotification) {
        if (!keyboardIsShow) {
            adjustingHeight(show: true, notification: notification)
            keyboardIsShow = true
        }
    }
    
    // Process when hide keyboard
    func keyboardWillHide(notification:NSNotification) {
        if (keyboardIsShow) {
            adjustingHeight(show: false, notification: notification)
            keyboardIsShow = false
        }
    }
    
    // Change bottom constraint of bottom item when show/ hide keyboard to push it up
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.btmConstraint.constant += changeInHeight
        })
    }
}
