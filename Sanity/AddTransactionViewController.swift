//
//  AddTransactionViewController.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class AddTransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetPicker: UIPickerView!
    var userEmail:String?
    var budgets = [Budget]()
    var categories = [Category]()
    var numRows = 1
    var selectedBudgetIndex = 0
    var selectedCategoryIndex = 0
    
    
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
            selectedBudgetIndex = 1
            fetchCategories()
        } else {
            selectedCategoryIndex = 2
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
                //self.transactionTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! AddTransactionCell
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
//        var categories = [String: Float]()
        
//        if(budgetNameTextField.text == ""){
//            showErrorAlert(message: "Budget must have a name")
//            return
//        }
        
        for cell in cells{
//            if cell.categoryNameTextField?.text == "" || cell.limitTextField?.text == ""{
//                showErrorAlert(message: "Please enter a value for all category fields or remove a category")
//                return
//            }else{
            //Each component is a wheel in the picker
            let chosenCategory = categories[cell.categoryPicker.selectedRow(inComponent: 0)]
            let amountSpent = cell.amountSpent.text!
            let optionalMemo = cell.optionalMemo.text
                
//            if categories[catKey] != nil {
//                showErrorAlert(message: "Category names must be unique")
//                return
//            }
//
//            categories[catKey] = limitVal
//            }
            let mTransaction = Transaction(memo: optionalMemo, linkedBudgets: [], paymentMethod: "",
                                          amount: Double(amountSpent)!, timestamp: Date())
            
            print(mTransaction)
            
            Firestore.firestore().collection("Users/\(userEmail!)/Budgets/\(budgets[selectedBudgetIndex].getName)/\(chosenCategory)/Transactions").document().setData(mTransaction.dictionary)
        }
        
        //Send categories and resetPeriods[index] to
        
        
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
    
    

}
