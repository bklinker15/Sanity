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
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //function to get notification settings index from firebase, creates it if DNE
    func getNotificationsIndex()->Int{
        var index: Int?
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)")
        collRef.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.documentID == "notificationsSettingsIndex"){
                        index = (document.data()["notificationsSettingsIndex"] as! Int)
                    }
                }
            }
        }

        if index != nil{
            return index!
        } else {
            return 0
        }
    }
    
    func updatePassword(password: String){
        if password == "" || password.count < 6 {
            self.errorLabel.text = "password must be at least 6 characters long"
            self.newPassword.text = ""
        }
        else{
            self.errorLabel.text = "password updated"
            self.errorLabel.textColor = UIColor.green
            self.newPassword.text = ""
            
            
        }
    }
    
    func setNotificationIndex(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)")
        var ref: DocumentReference? = nil
        ref = collRef.addDocument(data: [
            "notificationsSettingsIndex": index
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

        //set the value as the new value chosen on the picker

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["budget and threshold","budget only","none"]
        self.errorLabel.text = ""
        self.newPassword.text = ""
        
        //        var index: Int = getNotificationsIndex()
        //TODO: set picker view to correct index
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

