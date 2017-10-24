//
//  EditBudgetViewController.swift
//  Sanity
//
//  Created by Katie Wasserman on 18/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class EditBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    
  var resetPeriods = ["Never", "Daily", "Weekly", "Bi-Weekly", "Monthly", "Semi-Annually", "Annually"]
    var budgetName:String?
    var userEmail:String?
    var categories = [Category]()
    var budget:Budget?
    @IBOutlet weak var budgetNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    var numRows:Int!
    var resetInterval = 0
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var budgetPicker: UIPickerView!
    
    var docRef:DocumentReference!
    
    @IBOutlet weak var resetBudgetPeriod: UIButton!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var v:String = String(numRows)
        print("number of robs" + v)
        return 15
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resetPeriods[row]
    }
    
    @IBAction func resetPeriod(_ sender: Any) {
        var df:DocumentReference
        
        let budg = Budget(name: (budget?.name)!, resetDate: (budget?.resetDate)!, lastReset: (budget?.lastReset)!, resetInterval: self.resetInterval,
                          totalBudget: (budget?.totalBudget)!, budgetRemaining: (budget?.budgetRemaining)!, previousBudgetRemains: (budget?.previousBudgetRemains)!, previousBudgetLimits:(budget?.previousBudgetLimits)!)
        
        
        df = Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document((budget?.name)!)
        
        df.delete()
        
        Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document(budg.name).setData(budg.dictionary)
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let reset = ResetEnum(rawValue: resetPeriods[row]) else { return }
        switch reset {
        case .Never:
            resetInterval = 0
        case .Daily:
            resetInterval = 1
        case .Weekly:
            resetInterval = 7
        case .BiWeekly:
            resetInterval = 14
        case .Monthly:
            resetInterval = 31
        case .SemiAnnually:
            resetInterval = 178
        case .Annually:
            resetInterval = 356
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resetPeriods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "editCell") as! EditCategoryCell
        if indexPath.row < categories.count{
            let catName:String = categories[indexPath.row].name
            let catLimit:Double = categories[indexPath.row].spendingLimit
            let catLimitString:String = String(format:"%.2f", catLimit)
            cell.setup(catName: catName, catLimit: catLimitString,budName:(budget?.name)!, email:userEmail!, cat: categories[indexPath.row])
        } else {
            let p = [String]()
            let category = Category(name: "", paymentMethods: p, spendingLimit: 0.0, amountSpent: 0.0)
            
            cell.setup(catName:"", catLimit:"", budName:(budget?.name)!, email:userEmail!, cat: category)
        }

        return cell
    }
    
    func setFont(){
        budgetNameLabel.font = UIFont(name: "DidactGothic-Regular", size: 40)
        categoryLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            print (indexPath.row)
            if indexPath.row >= numRows-1{
                numRows = numRows - 1
                categoryTableView.reloadData()
            }
            else{
                deleteCat(catName:categories[indexPath.row].name)
                categories.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }

    }
    
    func deleteCat(catName:String){
        //var ref: DocumentReference?? = nil
    
        docRef = Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document((budget?.name)!).collection("Categories").document(catName)
            
        docRef.delete()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
        budgetNameLabel.text = budget?.name
        setFont()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat
        if (indexPath.row >= numRows){
            rowHeight = 0
        } else{
            rowHeight = 54
        }
        
        return rowHeight
    }
    
    func fetchCategories(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets/\((budget?.getName())!)/Categories")
        print("Users/\(userEmail!)/Budgets/\((budget?.getName())!)/Categories")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("In error block")
                print(err)
            } else {
                print("In categories flatMap")
                self.categories = querySnapshot!.documents.flatMap({Category(dictionary: $0.data())})
                self.categoryTableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        numRows = numRows + 1
        categoryTableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // delete budget button
    // edit categories (add or delete)
    // edit budget period
    
    
}
