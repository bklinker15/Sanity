//
//  TransactionViewController.swift
//  Sanity
//
//  Created by Katie Wasserman on 15/11/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var userEmail:String!
    var budgets = [Budget]()
    var transactions = [Transaction]()
    
    @IBOutlet weak var transactionTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transCell") as! TransactionCell
        let am:String = String(format:"%.2f", transactions[indexPath.row].amount)
        let budg:String
        if transactions[indexPath.row].linkedBudgets.count > 0{
            budg = transactions[indexPath.row].linkedBudgets[0]
        }
        else{
            budg = ""
        }
        
        cell.setUp(date:transactions[indexPath.row].timestamp.description, amount:am, budget:budg, memo:transactions[indexPath.row].memo!)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBudgets()
        
    }
    override func didReceiveMemoryWarning() {
        super.viewDidLoad()
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func fetchBudgets(){
    Firestore.firestore().collection("Users").document(self.userEmail).collection("Budgets").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.budgets = querySnapshot!.documents.flatMap({Budget(dictionary: $0.data())})
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                self.fetchCategories()
            }
        }
        
    }
    func fetchCategories(){
        for budget in budgets{
            var categories = [Category]()
        Firestore.firestore().collection("Users").document(self.userEmail).collection("Budgets").document(budget.name).collection("Categories").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    categories = querySnapshot!.documents.flatMap({Category(dictionary: $0.data())})
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.fetchTransactions(bud:budget.name, cat:categories)
                }
            }
        }
    }
    
    func fetchTransactions(bud:String, cat:[Category]){
        for cats in cat{
                Firestore.firestore().collection("Users").document(self.userEmail).collection("Budgets").document(bud).collection("Categories").document(cats.name).collection("Transactions").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var trans = [Transaction]()
                    trans = querySnapshot!.documents.flatMap({Transaction(dictionary: $0.data())})
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.transactions.append(contentsOf: trans)
                    self.transactionTableView.reloadData()
                }
            }
        }
        
    }
}
