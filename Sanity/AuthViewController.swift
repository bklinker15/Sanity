//
//  AuthViewController.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/5/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sanity: UILabel!
    
    @IBAction func submitButton(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            let emailText = emailTextField.text!.lowercased()
            
            if !isValidEmail(email: emailText){
                self.errorLabel.text = "Invalid email"
            }else if !isComplexPassword(password: passwordTextField.text!){
                self.errorLabel.text = "Password must be at least 6 characters long"
            }
                /* If login */
            else if segmentControl.selectedSegmentIndex == 0 {
                Auth.auth().signIn(withEmail: emailText, password: passwordTextField.text!, completion: {(user, error) in
                    if user != nil{
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        self.resetTextFields()
                    }else{
                        self.errorLabel.text = "Invalid login"
                    }
                })
            }
                /* If sign up */
            else if segmentControl.selectedSegmentIndex == 1{
                Auth.auth().createUser(withEmail: emailText, password: passwordTextField.text!, completion: { (user, error) in
                    if user != nil{
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        self.resetTextFields()
                    }else{
                        self.errorLabel.text = "Email is taken"
                    }
                })
            }
        }else{
            self.errorLabel.text = "Fields cannot be empty"
        }
    }
    

    func resetTextFields(){
        self.errorLabel.text = ""
        self.emailTextField.text = "";
        self.passwordTextField.text = ""
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "loginSegue":
                    //Target VC is embedded in NavVC, need to pull it out
                    let destination = segue.destination as? UINavigationController
                    if let vc = destination?.topViewController as? DashboardViewController {
                        vc.userEmail = emailTextField.text!.lowercased()
                    }
                default: break
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
        self.resetTextFields()
        setFonts()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setFonts(){
        sanity.font = UIFont(name: "DidactGothic-Regular", size: 60)
        submitButton.titleLabel!.font =  UIFont(name: "DidactGothic-Regular", size: 20)
        errorLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        forgotPasswordButton.titleLabel!.font =  UIFont(name: "DidactGothic-Regular", size: 20)
        emailTextField.font = UIFont(name: "DidactGothic-Regular", size: 20)
        passwordTextField.font = UIFont(name: "DidactGothic-Regular", size: 20)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordPress(_ sender: Any) {
        if emailTextField.text != nil && isValidEmail(email: self.emailTextField.text!){
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!.lowercased(), completion: {error in
                if error != nil {
                    self.errorLabel.text = "Unknown email"
                }else{
                    self.errorLabel.text = "Reset email sent"
                }
            })
        }else{
            self.errorLabel.text = "Please specify a valid email"
        }
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
        return password.count >= 6
    }
    
    func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



