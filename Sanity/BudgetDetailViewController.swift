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
    
    var budget:Budget?
    
    @IBOutlet weak var budgetNm: UILabel!
    @IBOutlet weak var daysReset: UILabel!
    @IBOutlet weak var budgetProg: UIProgressView!
    @IBOutlet weak var budgetLim: UILabel!
    @IBOutlet weak var fundsSpent: UILabel!
    @IBOutlet weak var fundsLeft: UILabel!
    
    
    @IBOutlet weak var numTotal: UILabel!
    
    @IBOutlet weak var numFunds: UILabel!
    
    @IBOutlet weak var numLeft: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        budgetNm.text = budget?.name;


        
        //budget limit
        var tot: Double
        tot = (budget?.totalBudget)!;
        numTotal.text = String(format:"%f", tot)
        
        // funds spent
        var spent: Double
        spent = (budget?.budgetRemaining)!;
        spent = tot-spent
        if spent < 0{
            spent = spent*(-1)
        }
        numFunds.text = String(format:"%f", spent)
        
        
        //remaining funds
        var rem: Double
        rem = (budget?.budgetRemaining)!;
        numLeft.text = String(format:"%f", rem)
        
        if (tot != 0){
            var percent:Float = Float(spent/tot)
            budgetProg.progress = (percent)
        }
        
        //days reset
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: (budget?.getResetDate())!)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        daysReset.text = (String(describing: components.day!))
        
        
    
    
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
