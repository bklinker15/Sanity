//
//  BudgetDetailViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/15/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class BudgetDetailViewController: UIViewController {
    var budgetName:String?
    var userEmail:String?
    var categories = [Category]()
    
    @IBOutlet weak var budgetNm: UILabel!
    @IBOutlet weak var daysReset: UILabel!
    @IBOutlet weak var budgetProg: UIProgressView!
    @IBOutlet weak var budgetLim: UILabel!
    @IBOutlet weak var fundsSpent: UILabel!
    @IBOutlet weak var fundsLeft: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        budgetNm.text = budgetName;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
