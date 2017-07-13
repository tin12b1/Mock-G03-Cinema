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
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    
    var isSignIn = true
    var isHidePassword = true
    var keyboardIsShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
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
        if (emailTextField.text == "" || passwordTextField.text == "") {
            self.displayMyAlertMessage(userMessage: "You must input all fields!")
        }
        else {
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let email = emailTextField.text
                let password = passwordTextField.text
                let valid = Struct.isValidEmail(testStr: email!)
                if (isSignIn) {
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
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
                        if ((password?.characters.count)! < 6) {
                            self.displayMyAlertMessage(userMessage: "Password must be at least 6 characters!")
                        }
                        else {
                            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
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
    
    // MARK: - Keyboard Hide/Show
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if !keyboardIsShow {
            adjustingHeight(show: true, notification: notification)
            keyboardIsShow = true
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if keyboardIsShow {
            adjustingHeight(show: false, notification: notification)
            keyboardIsShow = false
        }
    }
    
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
