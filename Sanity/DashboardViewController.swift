//
//  DashboardTableViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/7/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase
class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var userEmail: String!
    var budgets = [Budget]()
    
    @IBAction func addButtonPress(_ sender: Any) {
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Add", message: "Add new budget or transaction?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let transactionAction = UIAlertAction(title: "Transaction", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: "addTransactionSegue", sender: self)
        }
        
        let budgetAction = UIAlertAction(title: "Budget", style: UIAlertActionStyle.default) { (action) in
            self.performSegue(withIdentifier: "addBudgetSegue", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(transactionAction)
        myActionSheet.addAction(budgetAction)
        myActionSheet.addAction(cancelAction)
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBudgets()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }
    
    //Currently
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "budget", for: indexPath)
        if let cell = dequeued as? BudgetOverviewCell {
            let currentBudget = budgets[indexPath.row]
            cell.budgetName.text = currentBudget.getName()
            cell.budgetRemaining.text = String(describing: currentBudget.getBudgetRemaining)
            
            cell.budgetRemaining.textColor = UIColor.green
            
            if currentBudget.budgetRemaining > 0 {
                cell.budgetRemaining.textColor = UIColor.green
                cell.backgroundColor = UIColor(red: 212.00, green: 255.00, blue: 212.00, alpha: 1.00)
            }
            else {
                cell.budgetRemaining.textColor = UIColor.red
                cell.backgroundColor = UIColor(red: 255.00, green: 196.00, blue: 196.00, alpha: 1.00)
            }
            
            //need to somehow draw rectangle or update progress bar (unable to access it right now)
            var floatBudgetRemaining = Float(currentBudget.budgetRemaining)
            cell.progressBar.setProgress(floatBudgetRemaining, animated: true)
            //Stub for now, remember to actually calculate
            let calendar = NSCalendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: Date())
            let date2 = calendar.startOfDay(for: currentBudget.getResetDate())
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            
            cell.daysUntilReset.text = String(describing: components.day)
            return cell
        }
        return dequeued
    }
    
    //Trigger segue to budget detail view once a budget row is tapped in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "budgetDetail", sender: tableView.cellForRow(at: indexPath))
        
        performSegue(withIdentifier: "budgetDetail", sender: budgets[indexPath.row])
    }
    
    func fetchBudgets(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets")
        print("Users/\(userEmail!)/Budgets")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                self.budgets = querySnapshot!.documents.flatMap({Budget(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "addTransactionSegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Cancel"
                navigationItem.backBarButtonItem = backItem
                let vc = segue.destination as? AddTransactionViewController
                vc?.userEmail = userEmail
            case "addBudgetSegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Cancel"
                navigationItem.backBarButtonItem = backItem
                let vc = segue.destination as? AddBudgetViewController
                vc?.userEmail = userEmail
            case "budgetDetail":
                let vc = segue.destination as? BudgetDetailViewController
//                let cell = sender as? BudgetOverviewCell
//                vc?.budgetName = cell?.budgetName.text!
//                vc?.userEmail = userEmail
                let budget = sender as? Budget
                vc?.budget = budget
            default: break
            }
        }
    }

}
