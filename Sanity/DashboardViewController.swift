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
            cell.budgetName.text = currentBudget.name
            cell.budgetRemaining.text = String(describing: currentBudget.budgetRemaining)
            //Stub for now, remember to actually calculate
            cell.daysUntilReset.text = "10"
            return cell
        }
        return dequeued
    }
    
    //Trigger segue to budget detail view once a budget row is tapped in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "budgetDetail", sender: tableView.cellForRow(at: indexPath))
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
            case "addBudgetSegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Cancel"
                navigationItem.backBarButtonItem = backItem
            case "budgetDetail":
                let vc = segue.destination as? BudgetDetailViewController
                let cell = sender as? BudgetOverviewCell
                vc?.budgetName = cell?.budgetName.text!
            default: break
            }
        }
    }

}
