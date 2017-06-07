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
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(login, animated: true)
    }

    @IBAction func resetPasswordButtonClick(_ sender: Any) {
        if (emailTextField.text == "") {
            self.displayMyAlertMessage(userMessage: "You must input email!")
        }
        else if (!Struct.isValidEmail(testStr: emailTextField.text!)) {
            self.displayMyAlertMessage(userMessage: "Wrong email format!")
        }
        else {
            let email = emailTextField.text
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                if error != nil {
                    self.displayMyAlertMessage(userMessage: "Email unavailable in system!")
                }
                else {
                    self.displayMyAlertMessage(userMessage: "Reset password email sent, check your inbox!")
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
}
