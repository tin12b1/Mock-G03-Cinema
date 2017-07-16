//
//  AddUserInfoViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/1/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddUserInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Global variables
    @IBOutlet var btmConstraint: NSLayoutConstraint!
    @IBOutlet var agePickerView: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    let age: [Int] = Array(13...100)
    var ageSelected = 13
    var keyboardIsShow = false
    let userMessage = UserMessage.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agePickerView.dataSource = self
        agePickerView.delegate = self
        // Dismiss and hide/show keyboard
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddUserInfoViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserInfoViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(AddUserInfoViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUserInfoAvailable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Process when user click Save button
    @IBAction func saveButtonClick(_ sender: Any) {
        // Check if user didn't input name, address textfields
        if (nameTextField.text == "" || addressTextField.text == "") {
            self.displayMyAlertMessage(userMessage: userMessage.missingInput)
        }
        else {
            // Check internet connection
            if (!Reachability.isConnectedToNetwork()) {
                let srcNoInternet = self.storyboard?.instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
                self.present(srcNoInternet, animated: true)
            }
            else {
                let userId = Auth.auth().currentUser?.uid
                let userModel = User(name: nameTextField.text!, age: ageSelected, address: addressTextField.text!)
                // Save user info to database
                DAOUser.addNewUser(userId: userId!, userInfo: userModel, completionHandler: { (error) in
                    if (error == nil) {
                        self.performSegue(withIdentifier: "show account", sender: self)
                    } else {
                        self.displayMyAlertMessage(userMessage: (error?.localizedDescription)!)
                    }
                })
            }
        }
    }
    
    // MARK: - Age picker view datasource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return age.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageSelected = age[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(age[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - Helper methods
    
    // Check if user already had info
    func checkUserInfoAvailable() {
        let userId = Auth.auth().currentUser?.uid
        DAOUser.getUserInfo(userId: userId!, completionHandler: { (userInfo, error) in
            if (error == nil) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    // Display alert message
    func displayMyAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // Reset name and address textfield
    func resetTextField () {
        nameTextField.text?.removeAll()
        addressTextField.text?.removeAll()
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
