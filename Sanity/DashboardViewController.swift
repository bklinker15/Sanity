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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        budgets = fetchBudgets()
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
        return 1
    }
    
    //Currently
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "budget", for: indexPath)
        if let cell = dequeued as? BudgetOverviewCell {
            cell.budgetName.text = "Test"
            return cell
        }
        return dequeued
    }
    
    func fetchBudgets() -> [Budget]{
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail)/budgets")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                self.tableView.numberOfRows(inSection: (querySnapshot?.count)!)
                
            }
        }
    }

}
