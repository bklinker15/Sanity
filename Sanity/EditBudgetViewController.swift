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
    
    @IBOutlet weak var categoryTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryBudgetCell
        
        return cell
    }
    
    
    @IBOutlet weak var budgetNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
