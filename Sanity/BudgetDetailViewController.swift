//
//  BudgetDetailViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/15/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//
import UIKit
import Firebase

class BudgetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var budgetName:String?
    var userEmail:String?
    var categories = [Category]()
    
    var budget:Budget?
    
    @IBOutlet weak var budgetNameLabel: UILabel!
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var budgetProgress: UIProgressView!
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var fundsSpentLabel: UILabel!
    @IBOutlet weak var remainingFundsLabel: UILabel!

    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        
        budgetNameLabel.text = budget?.name
        
        var budgetLimit:Double = (budget?.totalBudget)!
        var remainingFunds:Double = (budget?.budgetRemaining)!
        var fundsSpent:Double = budgetLimit-remainingFunds
        if (fundsSpent < 0){
            fundsSpent = fundsSpent * -1
        }
        
        var budgetLimitString:String = String(format:"%.2f", budgetLimit )
        var remainingFundsString:String = String(format:"%.2f", remainingFunds )
        var fundsSpentString:String = String(format:"%.2f", fundsSpent )
        
        budgetLimitLabel.text = "Budget Limit: " + budgetLimitString
        fundsSpentLabel.text = "Funds spent so far: " + fundsSpentString
        remainingFundsLabel.text = "Remaining funds: " + remainingFundsString
        
        
        var percent:Float = Float(fundsSpent/budgetLimit)
        if percent >= 1.0{
            percent = 1.0
        }
        budgetProgress.progress = percent
        
        
        //days reset
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: (budget?.getResetDate())!)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        var days:String = (String(describing: components.day!))
        daysLeftLabel.text =  days + " left until the budget will reset."

        fetchCategories()
        print(categories.count)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func setFonts(){
        budgetLimitLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        daysLeftLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        remainingFundsLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        fundsSpentLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        budgetNameLabel.font = UIFont(name: "DidactGothic-Regular", size: 40)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryBudgetCell
        
        
        
        var catName:String = categories[indexPath.row].name

        var catLimit:Double = categories[indexPath.row].spendingLimit
        var catSpent:Double = categories[indexPath.row].amountSpent
        var catRemaining:Double = catLimit - catSpent
        
        var catLimitString:String = String(format: "%.2f", catLimit)
        var catSpentString:String = String(format: "%.2f", catSpent)
        var catRemainingString:String = String(format: "%.2f", catRemaining)
        
        var percent:Float = Float(catSpent/catLimit)
        if (percent >= 1.0){
            percent = 1.0
        }
        
    
        cell.setup(name: catName, prog: percent, limit: catLimitString, spent: catSpentString, left: catRemainingString)
        return cell
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
                print(self.categories.count)
            }
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
    
}

