//
//  ResetPasswordViewController.swift
//  Mock_G03_Cinema
//
//  Created by cntt17 on 6/7/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    // Global variables
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    var keyboardIsShow = false
    let userMessage = UserMessage.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dismiss and hide/show keyboard
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Process when user click Back button
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Process when user click Reset password button
    @IBAction func resetPasswordButtonClick(_ sender: Any) {
        // Validate email text field
        if (emailTextField.text == "") {
            self.displayMyAlertMessage(userMessage: userMessage.missingInput)
        }
        else if (!Struct.isValidEmail(testStr: emailTextField.text!)) {
            self.displayMyAlertMessage(userMessage: userMessage.invalidEmailFormat)
        }
        else {
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let email = emailTextField.text
                Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                    if (error != nil) {
                        self.displayMyAlertMessage(userMessage: self.userMessage.emailNotExist)
                    }
                    else {
                        let alertView = UIAlertController(title: "Success", message: self.userMessage.successResetPassword, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertView.addAction(action)
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Method
    
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
