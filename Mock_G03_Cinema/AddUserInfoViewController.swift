//
//  AddUserInfoViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/1/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class AddUserInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var agePickerView: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    
    let age: [Int] = Array(13...100)
    var ageSelected = 13

    override func viewDidLoad() {
        super.viewDidLoad()
        agePickerView.dataSource = self
        agePickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUserInfoAvailable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Process when user click Save button
    @IBAction func saveButtonClick(_ sender: Any) {
        if (nameTextField.text == "" || addressTextField.text == "") {
            let alert = UIAlertController(title: "Error", message: "You must input all fields!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let userId = Auth.auth().currentUser?.uid
            let userModel = User(name: nameTextField.text!, age: ageSelected, address: addressTextField.text!)
            DAOUser.addNewUser(userId: userId!, userInfo: userModel, completionHandler: { (error) in
                if error == nil {
                    self.performSegue(withIdentifier: "show account", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                }
            })
        }
    }
    
    func resetTextField () {
        nameTextField.text?.removeAll()
        addressTextField.text?.removeAll()
    }
    
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
    
    func checkUserInfoAvailable() {
        let userId = Auth.auth().currentUser?.uid
        DAOUser.getUserInfo(userId: userId!, completionHandler: { (userInfo, error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
