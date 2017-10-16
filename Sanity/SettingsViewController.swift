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

class SettingsViewController: UIViewController {
    var userEmail: String?
    var notificationSettingsIndex: Int = 0
    
    var notificationSettings = ["budget exceeded and threshold exceeded","budget exceeded only","none"]
    
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
            //show error message "password must be at least 6 characters"
        }
    }

    func setNotificationIndex(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)")
        var ref: DocumentReference? = nil
        ref = collRef.addDocument(data: [
            "notificationsSettingsIndex": 
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
//        var index: Int = getNotificationsIndex()
        //TODO: set picker view to correct index
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
