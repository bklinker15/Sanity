//
//  AddBudgetViewController.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class AddBudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var userEmail:String?
    var resetPeriods = ["Never", "Daily", "Weekly", "Bi-weekly", "Monthly", "3 Months", "6 Months", "Yearly"]
    var numRows = 1
    var selectedResetIndex = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resetPeriods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resetPeriods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedResetIndex = row
    }
    

    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var budgetNameTextField: UITextField!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        
        cell.setup()
        return cell
    }
    
    @IBAction func addCategoryButtonPress(_ sender: Any) {
        numRows = numRows + 1
        categoryTableView.beginUpdates()
        categoryTableView.insertRows(at: [IndexPath(row: numRows-1, section: 0)], with: .automatic)
        categoryTableView.endUpdates()
    }
    
    @IBAction func removeCategoryButtonPress(_ sender: Any) {
        if numRows > 1{
            numRows = numRows - 1
            categoryTableView.beginUpdates()
            categoryTableView.deleteRows(at: [IndexPath(row: numRows, section: 0)], with: .automatic)
            categoryTableView.endUpdates()
        }else{
            showErrorAlert(message: "Budget must have at least one category")
        }
    }
    
    @IBAction func createBudgetButtonPress(_ sender: Any) {
        let cells = self.categoryTableView.visibleCells as! Array<CategoryCell>
        var categories = [String: Double]()
        
        if(budgetNameTextField.text == ""){
            showErrorAlert(message: "Budget must have a name")
            return
        }
        
        for cell in cells{
            if cell.categoryNameTextField?.text == "" || cell.limitTextField?.text == ""{
                showErrorAlert(message: "Please enter a value for all category fields or remove a category")
                return
            }else{
                let catKey = cell.categoryNameTextField.text!
                let limitVal = Double(cell.limitTextField.text!)
                
                if categories[catKey] != nil {
                    showErrorAlert(message: "Category names must be unique")
                    return
                }
                
                categories[catKey] = limitVal
            }
        }
        
        //Send categories and resetPeriods[index] to
        createBudget(budgetName: budgetNameTextField.text! ,categories: categories, resetPeriod: resetPeriods[selectedResetIndex])
    }
    
    func createBudget(budgetName: String, categories:[String: Double], resetPeriod: String){
        var sum = 0.0
        
        for (_, limit) in categories{
            sum = sum + limit
        }
        
        let budget = Budget(name: budgetName, resetDate: Date(), lastReset: Date(), resetInterval: -1, totalBudget: sum, budgetRemaining: sum)
        
        Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document(budgetName).setData(budget.dictionary)
        
        for (name, limit) in categories{
            let category = Category(name: name, paymentMethods: [], spendingLimit: limit)
            Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document(budgetName).collection("Categories").document(name).setData(category.dictionary)
        }
        
        self.navigationController?.popViewController(animated: true)
        if let dash = self.navigationController?.topViewController as? DashboardViewController{
            dash.fetchBudgets()
        }
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
