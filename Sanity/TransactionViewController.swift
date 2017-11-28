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
    var budgetName:String!
    var transactions = [Transaction]()
    var transactionIDs = [String]()
    
    @IBOutlet weak var transactionTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            deleteTransaction(index:indexPath.row, catName: transactions[indexPath.row].linkedCategory)
        }
    }
    func deleteTransaction(index:Int, catName:String){
        
        var docRef:DocumentReference
        docRef = Firestore.firestore().collection("Users").document(userEmail!).collection("Budgets").document((budgetName)!).collection("Categories").document(catName).collection("Transactions").document(transactionIDs[index])
        
        docRef.delete()
        
        
        
        
        transactions.removeAll()
        transactionIDs.removeAll()
        fetchCategories()
        transactionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transCell") as! TransactionCell
        let am:String = String(format:"%.2f", transactions[indexPath.row].amount)
        let d = transactions[indexPath.row].timestamp.description
        let index = d.index(d.startIndex, offsetBy: 10)
        let mySubstring = String (d.prefix(upTo: index))
        
        cell.setUp(date:mySubstring, amount:am, memo:transactions[indexPath.row].memo!)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
        
    }
    override func didReceiveMemoryWarning() {
        super.viewDidLoad()
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

    func fetchCategories(){
        var categories = [Category]()
    Firestore.firestore().collection("Users").document(self.userEmail).collection("Budgets").document(budgetName).collection("Categories").getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                categories = querySnapshot!.documents.flatMap({Category(dictionary: $0.data())})
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                self.fetchTransactions(cat:categories)
            
            }
        }
    }
    
    func fetchTransactions( cat:[Category]){
        for cats in cat{
                Firestore.firestore().collection("Users").document(self.userEmail).collection("Budgets").document(budgetName).collection("Categories").document(cats.name).collection("Transactions").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var trans = [Transaction]()
                    trans = querySnapshot!.documents.flatMap({Transaction(dictionary: $0.data())})
                    var transId = [String]()
                    for document in querySnapshot!.documents {
                        print(document.documentID)
                        transId.append(document.documentID)
                        print("TRANSACTION")
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.transactions.append(contentsOf: trans)
                    self.transactionIDs.append(contentsOf: transId)
                    self.transactionTableView.reloadData()
                }
            }
        }
        
    }
}
