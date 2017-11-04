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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 101
        fetchBudgets()
        tableView.reloadData()
        tableView.refreshControl = self.refreshControl
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(refreshControl: UIRefreshControl){
        self.fetchBudgets()
        refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "budget", for: indexPath)
        if let cell = dequeued as? BudgetOverviewCell {
            let currentBudget = budgets[indexPath.row]
            cell.budgetName.text = currentBudget.getName()
            
            cell.budgetRemaining.text = "$" + String(format: "%.2f", currentBudget.getBudgetRemaining());
         
            cell.budgetRemaining.textColor = UIColor.green
            
            if currentBudget.getBudgetRemaining() > 0.0 {
                cell.budgetRemaining.textColor = UIColor.green
                cell.backgroundColor = UIColor(red: 212, green: 255, blue: 212, alpha: 1)
            }
            else {
                cell.budgetRemaining.textColor = UIColor.red
                cell.backgroundColor = UIColor(red: 255, green: 196, blue: 196, alpha: 1)
            }
            var floatBudgetRemaining = Float(currentBudget.getBudgetRemaining())
            floatBudgetRemaining = floatBudgetRemaining / Float(currentBudget.getTotalBudget())
            cell.progressBar.setProgress(floatBudgetRemaining, animated: false)
            
            
            let calendar = NSCalendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: Date())
            let date2 = calendar.startOfDay(for: currentBudget.getResetDate())
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            
            cell.daysUntilReset.text = (String(describing: components.day!)) + " days left"
            return cell
        }
        return dequeued
    }
    
    //Trigger segue to budget detail view once a budget row is tapped in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "budgetDetail", sender: tableView.cellForRow(at: indexPath))
        
        performSegue(withIdentifier: "budgetDet", sender: budgets[indexPath.row])
    }
    
    func fetchBudgets(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets")
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
            case "budgetDet":
                let vc = segue.destination as? BudgetDetailViewController
                //                let cell = sender as? BudgetOverviewCell
                //                vc?.budgetName = cell?.budgetName.text!
                //                vc?.userEmail = userEmail
                let budget = sender as? Budget
                vc?.budget = budget
                vc?.userEmail = userEmail
            case "settingsSegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Budgets"
                navigationItem.backBarButtonItem = backItem
                let vc = segue.destination as? SettingsViewController
                vc?.userEmail = userEmail
            default: break
            }
        }
    }
    
}
