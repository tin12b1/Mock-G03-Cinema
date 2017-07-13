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
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    var keyboardIsShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func resetPasswordButtonClick(_ sender: Any) {
        if (emailTextField.text == "") {
            self.displayMyAlertMessage(userMessage: "You must input email!")
        }
        else if (!Struct.isValidEmail(testStr: emailTextField.text!)) {
            self.displayMyAlertMessage(userMessage: "Wrong email format!")
        }
        else {
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let email = emailTextField.text
                Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                    if error != nil {
                        self.displayMyAlertMessage(userMessage: "Email unavailable in system!")
                    }
                    else {
                        let alertView = UIAlertController(title: "Success", message: "Reset password email sent, check your inbox!", preferredStyle: .alert)
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
