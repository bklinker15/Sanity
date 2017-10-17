//
//  BudgetDetailViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/15/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Firebase

class BudgetDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
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
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var numLeft: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        budgetNm.text = budget?.name;


        
        //budget limit
        var tot: Double
        tot = (budget?.totalBudget)!;
        numTotal.text = String(format:"%.2f", tot)
        
        // funds spent
        var spent: Double
        spent = (budget?.budgetRemaining)!;
        spent = tot-spent
        if spent < 0{
            spent = spent*(-1)
        }
        numFunds.text = String(format:"%.2f", spent)
        
        
        //remaining funds
        var rem: Double
        rem = (budget?.budgetRemaining)!;
        numLeft.text = String(format:"%.2f", rem)
        
        if (tot != 0){
            var percent:Float = Float(spent/tot)
            budgetProg.setProgress(percent, animated: false)
        }
        
        //days reset
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: (budget?.getResetDate())!)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        daysReset.text = (String(describing: components.day!))
        
        
        fetchCategories()
        
        print(categories.count)
        print("success")
        //tableView.registerClass(MyCell.self, forCellReuseIdentifer: "cellId")
        //addCats()
        
    
    }
    
//    func addCats(){
//        var i = 0
//        for category in categories{
//            categoryTableView.beginUpdates()
//            categoryTableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
//            categoryTableView.endUpdates()
//            i = i+1
//        }
//    }

    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryBudgetCell") as! CategoryBudgetCell
        
        var nm: String
        nm = categories[indexPath.row].name;
        
        var to: Double
        to = (categories[indexPath.row].spendingLimit);
        var tot: String
        tot = String(format:"%.2f", to)
        
        
        //         funds spent
        var spen: Double
        spen = (categories[indexPath.row].amountSpent);
        if spen < 0{
            spen = spen*(-1)
        }
        
        var spent: String
        spent = String(format:"%.2f", spen)
        
        //remaining funds
        var remm: Double
        remm = to-spen
        
        var rem: String
        rem = String(format:"%.2f", remm)
        
        //
        //
        var prog: Float
        prog = 0.0
        if (to != 0){
            var percent:Float = Float(spen/to)
            if to >= 1.0{
                prog = percent
            } else{
                prog = 1.0
            }
        }
        //
        //
        //
        
        
        cell.setup(name: nm, prog: prog, limit: tot, spent: spent, left: rem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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

