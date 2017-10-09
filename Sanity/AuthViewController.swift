//
//  AuthViewController.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/5/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func submitButton(_ sender: UIButton) {
        print("submit")
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            if !isValidEmail(email: emailTextField.text!){
                self.errorLabel.text = "Invalid email"
            }else if !isComplexPassword(password: passwordTextField.text!){
                self.errorLabel.text = "Password must be at least 3 characters long"
            }
                /* If login */
            else if segmentControl.selectedSegmentIndex == 0 {
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                    if user != nil{
                        print("LOGIN Success")
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else{
                        print("error")
                        self.errorLabel.text = "Invalid login"
                    }
                })
            }
                /* If sign up */
            else if segmentControl.selectedSegmentIndex == 1{
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    if user != nil{
                        print("Sign up Success")
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else{
                        print(error!)
                        self.errorLabel.text = "Invalid login"
                    }
                    
                })
            }
        }else{
            self.errorLabel.text = "Fields cannot be empty"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "loginSegue":
                    //Target VC is embedded in NavVC, need to pull it out
                    let destination = segue.destination as? UINavigationController
                    if let vc = destination?.topViewController as? DashboardViewController {
                        vc.userEmail = emailTextField.text!
                    }
                default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func isComplexPassword(password:String) -> Bool {
        //TODO: password validation
        return password.count >= 3
    }
    
    func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}


