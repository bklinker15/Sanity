//
//  ViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/1/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBAction func logoutButtonPress(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
        
        
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

