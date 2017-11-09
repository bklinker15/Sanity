//
//  EditCategoryCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 18/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class EditCategoryCell: UITableViewCell {
    
    var budgetName:String!
    var userEmail:String!
    var category:Category!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var catLimitField: UITextField!

    @IBOutlet weak var catNameField: UITextField!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var editButton: UIButton!
    public func setup(catName:String, catLimit: String, budName:String, email:String, cat:Category, editBudg: UIViewController){
        catNameField.text = catName
        catLimitField.text = catLimit
        catLimitField.keyboardType = UIKeyboardType.decimalPad
        budgetName = budName
        userEmail = email
        category = cat
        
        if !catName.isEmpty {
            catNameField.isUserInteractionEnabled = false
            catLimitField.isUserInteractionEnabled = false
            editButton.setImage(UIImage(named:"edit.png"), for: .normal)
        }
        else {
            editButton.setImage(UIImage(named:"check.png"), for: .normal)
        }
        setFont()
    }

    @IBAction func editCategory(_ sender: UIButton) {
        if catLimitField.isUserInteractionEnabled == true{
            saveEdit()
        }
        else{
            editButton.setImage(UIImage(named:"check.png"), for: .normal)
            catLimitField.isUserInteractionEnabled = true
        }
        
    }
    
    func saveEdit(){
        if catNameField.isUserInteractionEnabled == true{
            //if it's a new category story in database
            let li:String = catLimitField.text!
            let lim:Double = Double(li)!
            let p = [String]()
            let category = Category(name: catNameField.text!, paymentMethods: p, spendingLimit: lim, amountSpent: 0.00)
        Firestore.firestore().collection("Users").document(userEmail).collection("Budgets").document(budgetName).collection("Categories").document(catNameField.text!).setData(category.dictionary)
            catNameField.isUserInteractionEnabled = false
            catLimitField.isUserInteractionEnabled = false
            editButton.setImage(UIImage(named:"edit.png"), for: .normal)
        } else{
            let li:String = catLimitField.text!
            let lim:Double = Double(li)!
            let categor = Category(name: catNameField.text!, paymentMethods: category.paymentMethods, spendingLimit: lim, amountSpent: category.amountSpent)
//            Firestore.firestore().collection("Users/\(userEmail!)/Budgets/\(budgetName)/Categories").document(category.name).setData(categor.dictionary)
            
            let docRef:DocumentReference = Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document(budgetName).collection("Categories").document(category.name)
            
            docRef.delete()
            
        Firestore.firestore().collection("Users").document(userEmail).collection("Budgets").document(budgetName).collection("Categories").document(catNameField.text!).setData(categor.dictionary)
            
             editButton.setImage(UIImage(named:"edit.png"), for: .normal)
            catLimitField.isUserInteractionEnabled = false
            //if it's an edit in category limit
        }
    }

    func setFont(){
        catNameField.font = UIFont(name: "DidactGothic-Regular", size: 20)
        catLimitField.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }

}
