//
//  ChangePasswordViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/2/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    var keyboardIsShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        resetTextField()
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmButtonClick(_ sender: Any) {
        if (oldPasswordTextField.text == "" || newPasswordTextField.text == "" || confirmPasswordTextField.text == "") {
            let alert = UIAlertController(title: "Error", message: "You must fill all fields!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.resetTextField()
            })
        }
        else if ((newPasswordTextField.text?.characters.count)! < 6) {
            let alert = UIAlertController(title: "Error", message: "Password atleast 6 characters!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.resetTextField()
            })
        }
        else if (newPasswordTextField.text != confirmPasswordTextField.text) {
            let alert = UIAlertController(title: "Error", message: "New password mismatch!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.resetTextField()
            })
        }
        else {
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let user = Auth.auth().currentUser
                let credential: AuthCredential
                
                // Prompt the user to re-provide their sign-in credentials
                credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
                
                user?.reauthenticate(with: credential) { error in
                    if error != nil {
                        // An error happened.
                        let alert = UIAlertController(title: "Error", message: "Old password mismatch!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: {
                            self.resetTextField()
                        })
                    } else {
                        // User re-authenticated.
                        user?.updatePassword(to: self.newPasswordTextField.text!) { (error) in
                            if error != nil {
                                self.displayMyAlertMessage(userMessage: "Change password failed!")
                            } else {
                                let alertView = UIAlertController(title: "Success", message: "Password changed!", preferredStyle: .alert)
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
        }
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func resetTextField() {
        confirmPasswordTextField.text?.removeAll()
        newPasswordTextField.text?.removeAll()
        oldPasswordTextField.text?.removeAll()
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
