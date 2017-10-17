//
//  SettingsViewController.swift
//  Sanity
//
//  Created by Nicholas Kaimakis on 10/13/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var userEmail: String?
    var notificationSettingsIndex: Int = 0
    var index: Int = 0
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func saveNotificationSettings(_ sender: UIButton) {
        let index = self.picker.selectedRow(inComponent: 0)
        let docRef = Firestore.firestore().collection("Users").document(userEmail!)
        docRef.setData(["notificationsSettingsIndex": index])
        self.errorLabel.text = "settings saved"
        self.errorLabel.textColor = UIColor.green
    }
    @IBAction func savePassword(_ sender: Any) {
        updatePassword(password: newPassword.text!)
    }
    
    //function to set notification settings index in UI from firebase, creates it if DNE
    func setNotificationsIndexUI() {
        let docRef = Firestore.firestore().collection("Users").document(userEmail!)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.data()["notificationsSettingsIndex"] != nil {
                    self.picker.selectRow(document.data()["notificationsSettingsIndex"] as! Int, inComponent:0, animated: true)
                } else {
                    docRef.setData(["notificationsSettingsIndex": 0])
                    self.picker.selectRow(0, inComponent:0, animated: true)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updatePassword(password: String){
        if password == "" || password.count < 6 {
            self.errorLabel.text = "password must be at least 6 characters long"
            self.newPassword.text = ""
        }
        else{
            let user = Auth.auth().currentUser
            user?.updatePassword(to: password, completion: { error in
                if error != nil{
                    self.errorLabel.text = "error updating password"
                    self.errorLabel.textColor = UIColor.red
                } else {
                    //success
                    self.errorLabel.text = "password updated"
                    self.errorLabel.textColor = UIColor.green
                }
                self.newPassword.text = ""
            })
        }
    }
    
    @IBAction func logoutButtonPress(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
        }
        self.navigationController?.popViewController(animated: false)
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["budget and threshold","budget only","none"]
        self.errorLabel.text = ""
        self.newPassword.text = ""
        
        //set notifications index to the setting stored in FB
        setNotificationsIndexUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}

