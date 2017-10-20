//
//  EditBudgetViewController.swift
//  Sanity
//
//  Created by Katie Wasserman on 18/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class EditBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var budgetName:String?
    var userEmail:String?
    var categories = [Category]()
    var budget:Budget?
    @IBOutlet weak var budgetNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    var docRef:DocumentReference!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "editCell") as! EditCategoryCell
        
        var catName:String = categories[indexPath.row].name
        var catLimit:Double = categories[indexPath.row].spendingLimit
        var catLimitString:String = String(format:"%.2f", catLimit)
        
        cell.setup(catName: catName, catLimit: catLimitString)
        
        return cell
    }
    
    func setFont(){
        budgetNameLabel.font = UIFont(name: "DidactGothic-Regular", size: 40)
        categoryLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            deleteCat(catName:categories[indexPath.row].name)
            categories.remove(at: indexPath.row)
            tableView.reloadData()
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
        return 54
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
    }
    
    
    // delete budget button
    // edit categories (add or delete)
    // edit budget period
    
    
}
