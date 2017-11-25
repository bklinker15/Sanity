//
//  AddTransactionViewController.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class AddTransactionViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetPicker: UIPickerView!
    var userEmail:String?
    var budgets = [Budget]()
    var categories = [Category]()
    var numRows = 1
    var selectedBudgetIndex = 0
    var selectedCategoryIndex = 0
    var lastCategory: String = "no category"
    
    
    @IBOutlet weak var transactionTableView: UITableView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return budgets.count
        } else {
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return budgets[row].getName()
        } else {
            return categories[row].getName()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedBudgetIndex = row
            fetchCategories()
        } else {
            selectedCategoryIndex = row
        }
    }
    
    func fetchBudgets(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets")
        print("Users/\(userEmail!)/Budgets")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                self.budgets = querySnapshot!.documents.flatMap({Budget(dictionary: $0.data())})
                self.fetchCategories()
                self.budgetPicker.reloadAllComponents()
                self.transactionTableView.reloadData()
            }
        }
    }
    
    func fetchCategories(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets/\(budgets[selectedBudgetIndex].getName())/Categories")
        print("Users/\(userEmail!)/Budgets/\(budgets[selectedBudgetIndex].getName())/Categories")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("In error block")
                print(err)
            } else {
                print("In categories flatMap")
                self.categories = querySnapshot!.documents.flatMap({Category(dictionary: $0.data())})
                self.transactionTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! AddTransactionCell
        cell.categoryPicker.reloadAllComponents()
        cell.amountSpent.delegate = self
        cell.optionalMemo.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @IBAction func addTransactionButtonPress(_ sender: Any) {
        numRows = numRows + 1
        transactionTableView.beginUpdates()
        transactionTableView.insertRows(at: [IndexPath(row: numRows-1, section: 0)], with: .automatic)
        transactionTableView.endUpdates()
    }
    
    @IBAction func removeTransactionButtonPress(_ sender: Any) {
        if numRows > 1{
            numRows = numRows - 1
            transactionTableView.beginUpdates()
            transactionTableView.deleteRows(at: [IndexPath(row: numRows, section: 0)], with: .automatic)
            transactionTableView.endUpdates()
        }else{
            showErrorAlert(message: "You must add at least one transcation")
        }
    }
    
    @IBAction func addTransactionsButtonPress(_ sender: Any) {
        let cells = self.transactionTableView.visibleCells as! Array<AddTransactionCell>
        var amountAdded:Double = 0.00
        for cell in cells{
            //Each component is a wheel in the picker
            let chosenCategory = categories[cell.categoryPicker.selectedRow(inComponent: 0)]
            let amountSpent = cell.amountSpent.text!
            let optionalMemo = cell.optionalMemo.text
            let mTransaction = Transaction(memo: optionalMemo, linkedBudget:budgets[selectedBudgetIndex].getName(),
                                          amount: Double(amountSpent)!, timestamp: Date())
            let mCategory = Category(name: chosenCategory.getName(), paymentMethods: chosenCategory.getPaymentMethods(), spendingLimit: chosenCategory.getSpendingLimit(), amountSpent: (chosenCategory.getAmountSpent() + Double(amountSpent)!))
            
            lastCategory = chosenCategory.getName()
            //Mirror database update locally so we're working with correct values for subsequent updates
            categories[cell.categoryPicker.selectedRow(inComponent: 0)] = Category(name: chosenCategory.getName(), paymentMethods: chosenCategory.getPaymentMethods(), spendingLimit: chosenCategory.getSpendingLimit(), amountSpent:(chosenCategory.getAmountSpent() + Double(amountSpent)!))
            amountAdded += Double(amountSpent)!
            
            //Add Transaction
            Firestore.firestore().collection("Users").document(self.userEmail!).collection("Budgets").document(budgets[selectedBudgetIndex].getName()).collection("Categories").document(chosenCategory.getName()).collection("Transactions").addDocument(data: mTransaction.dictionary)
            
            //Update Category
            Firestore.firestore().collection("Users/\(userEmail!)/Budgets/\(budgets[selectedBudgetIndex].getName())/Categories").document(chosenCategory.getName()).setData(mCategory.dictionary)
            
        }
        //Update the selected budget with the total amount added to decrement what we have left
        Firestore.firestore().document("Users/\(userEmail!)/Budgets/\(budgets[selectedBudgetIndex].getName())").updateData(["budgetRemaining":budgets[selectedBudgetIndex].getBudgetRemaining() - amountAdded]){ err in
            if err == nil{
                let budgetRemainingDouble = self.budgets[self.selectedBudgetIndex].getBudgetRemaining() - amountAdded
                
                if budgetRemainingDouble <= 0 {
                    self.navigationController?.popViewController(animated: true)
                    if let dash = self.navigationController?.topViewController as? DashboardViewController{
                        dash.fetchBudgets()
                    }
                    
                    let alertController = UIAlertController(title: "Budget Exceeded!", message: "Budget total has been exceeded! Your budget balance is $" + String(budgetRemainingDouble) + " and you exceeded this limit in the " + self.lastCategory + " category", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)

                }
                else if budgetRemainingDouble < self.budgets[self.selectedBudgetIndex].getNotificationThreshold() {
                    self.navigationController?.popViewController(animated: true)
                    if let dash = self.navigationController?.topViewController as? DashboardViewController{
                        dash.fetchBudgets()
                    }
                    
                    let alertController = UIAlertController(title: "Threshold Exceeded!", message: "Your set threshold of $" + String(self.budgets[self.selectedBudgetIndex].getNotificationThreshold()) + " out of your total budget of $" + String(self.budgets[self.selectedBudgetIndex].getTotalBudget()) + " has been exceeded!  You exceeded this threshold in the " + self.lastCategory + " category.  Your current balance is now $" + String(budgetRemainingDouble), preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.navigationController?.topViewController?.present(alertController, animated: true, completion: nil)
                }
                
//                for i in 0 ..< self.categories.count {
//                    if self.categories[i].getAmountSpent() >= self.categories[i].getSpendingLimit() {
//                        self.createAlert(title: "Category Exceeded!", message: "You have exceeded your limit of $" + String(self.categories[i].getSpendingLimit()) + " in the " + self.categories[i].getName() + " category!  Current category balance is now $" + String(self.categories[i].getSpendingLimit() - self.categories[i].getAmountSpent()))
//                    }
//                }
            }else{
                print("Error updating budget remaining amount")
            }
        }
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showErrorAlert(message: String){
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTableView.rowHeight = UITableViewAutomaticDimension
        transactionTableView.estimatedRowHeight = 183
        fetchBudgets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
