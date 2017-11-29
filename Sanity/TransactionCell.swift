//
//  TransactionCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 15/11/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase


class TransactionCell: UITableViewCell{
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var memoLabel: UITextField!

    var transaction:Transaction!
    var transactionID:String!
    var userEmail:String!
    var budget:Budget!
    var amount:Double!

    func setUp(date:String, amount:String, memo:String, trans:Transaction, transid:String, userE:String, bud:Budget){

        setFont()
        dateLabel.text = date
        amountLabel.text = amount
        memoLabel.text = memo
        
        self.amount = Double(amount)
        
        dateLabel.isUserInteractionEnabled = false
        amountLabel.isUserInteractionEnabled = false
        memoLabel.isUserInteractionEnabled = false
        
        transaction = trans
        transactionID = transid
        userEmail = userE
        budget = bud
    }
    
    @IBAction func editTrans(_ sender: Any) {
        if (amountLabel.isUserInteractionEnabled){
            // save edit
            saveEdit()
        }else{
            editButton.setImage(UIImage(named:"check.png"), for: .normal)
            amountLabel.isUserInteractionEnabled = true
            memoLabel.isUserInteractionEnabled = true
            //save edit
        }
    }
    func saveEdit(){
        if (!(amountLabel.text?.isEmpty)!){
             editButton.setImage(UIImage(named:"edit.png"), for: .normal)
            
            let am:String
            am = amountLabel.text!
            let a = Double(am)
            
            let mTransaction = Transaction(memo: memoLabel.text, linkedBudget: transaction.linkedBudget, linkedCategory: transaction.linkedCategory,
                                           amount: a!, timestamp: transaction.timestamp)
        Firestore.firestore().collection("Users").document(userEmail).collection("Budgets").document(transaction.linkedBudget).collection("Categories").document(transaction.linkedCategory).collection("Transactions").document(transactionID).setData(mTransaction.dictionary)
            
            
            self.amount = Double(self.amount) - Double(a!)
            
            let bu = Budget(name: budget.name, resetDate: budget.resetDate, lastReset: budget.lastReset, resetInterval: budget.resetInterval,
                            totalBudget: budget.totalBudget, budgetRemaining: budget.budgetRemaining + amount, previousBudgetRemains: budget.previousBudgetRemains, previousBudgetLimits: budget.previousBudgetRemains, notificationThreshold: budget.notificationThreshold, thresholdEmailSent: budget.thresholdEmailSent)
            var df:DocumentReference
            df = Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document((budget?.name)!)
            
            df.delete()
            
        Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document(bu.name).setData(bu.dictionary)
            
            
            amountLabel.isUserInteractionEnabled = false
            memoLabel.isUserInteractionEnabled = false
        }
    }
    func setFont(){
        dateLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
        amountLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
        memoLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
    }
}
