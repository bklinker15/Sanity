//
//  BudgetDetailViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/15/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//
import UIKit
import Firebase
import Charts

class BudgetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var budgetName:String?
    var userEmail:String?
    var categories = [Category]()
    
    var budget:Budget?
    
    var budgets = [Budget]()
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    //call when any values change within a budget
    @IBAction func renderCharts() {
        pieChartUpdate()
    }
    
    func pieChartUpdate () {
        //update this later to show category dispersion
        let budgetLimit:Double = (budget?.totalBudget)!
        let remainingFunds:Double = (budget?.budgetRemaining)! < 0.0 ? 0.0 : (budget?.budgetRemaining)!
        let fundsSpent:Double = budgetLimit-remainingFunds
        
        let spentEntry = PieChartDataEntry(value: Double(fundsSpent), label: "Dollars Spent")
        let remainingEntry = PieChartDataEntry(value: Double(remainingFunds), label: "Dollars Remaining")
        let dataSet = PieChartDataSet(values: [spentEntry, remainingEntry], label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = "Total Current Spending"
        pieChart.chartDescription?.font = UIFont(name: "DidactGothic-Regular", size: 16)!
        dataSet.entryLabelFont = UIFont(name: "DidactGothic-Regular", size: 12)!
        dataSet.valueFont = UIFont(name: "DidactGothic-Regular", size: 12)!
        
        //This must stay at end
        pieChart.notifyDataSetChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        self.title = budget?.getName()
        
        reload()

        fetchCategories()
        print(categories.count)
        pieChartUpdate()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFonts()
        
        fetchBudgets()

        reload()
        
        fetchCategories()
        print(categories.count)
        pieChartUpdate()
    }
    
    
    func setFonts(){
        budgetLeftLabel.font = UIFont(name: "DidactGothic-Regular", size: 15)
        daysLeftLabel.font = UIFont(name: "DidactGothic-Regular", size: 15)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "editSegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Budgets"
                navigationItem.backBarButtonItem = backItem
                
                let vc = segue.destination as? EditBudgetViewController
                vc?.budget = self.budget
                vc?.userEmail = self.userEmail
                vc?.numRows = self.categories.count
                vc?.budViewController = self
            case "historySegue":
                let backItem = UIBarButtonItem()
                backItem.title = "Budget Detail"
                navigationItem.backBarButtonItem = backItem
                
                let vc = segue.destination as? BudgetHistoryViewController
                vc?.budget = self.budget
                vc?.budgetName = self.budget?.name
                vc?.userEmail = self.userEmail
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryBudgetCell
        
        let catName:String = categories[indexPath.row].name

        let catLimit:Double = categories[indexPath.row].spendingLimit
        let catSpent:Double = categories[indexPath.row].amountSpent
        let catRemaining:Double = catLimit - catSpent
    
        cell.setup(name: catName, spent: catSpent, remaining: catRemaining)
        return cell
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
                print(self.categories.count)
            }
        }
    }
    
    func fetchBudgets(){
        let collRef: CollectionReference = Firestore.firestore().collection("Users/\(userEmail!)/Budgets")
        collRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                self.budgets = querySnapshot!.documents.flatMap({Budget(dictionary: $0.data())})
                DispatchQueue.main.async {
                    for b in self.budgets{
                        if b.name == self.budget?.name{
                            self.budget = b
                        }
                    }
                }
            }
        }
        print(budget?.totalBudget)
        reload()
    }
    
    func reload(){
        let budgetLimit:Double = (budget?.totalBudget)!
        let remainingFunds:Double = (budget?.budgetRemaining)!
        var fundsSpent:Double = budgetLimit-remainingFunds
        if (fundsSpent < 0){
            fundsSpent = fundsSpent * -1
        }
        
        let budgetLimitStringVal:String = String(format:"%.2f", budgetLimit )
        let remainingFundsStringVal:String = String(format:"%.2f", remainingFunds )
        let budgetLimitString = "$" + budgetLimitStringVal
        let remainingFundsString = "$" + remainingFundsStringVal
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        budgetLeftLabel.text = remainingFundsString + " remaining of " + budgetLimitString
        
        //days reset
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: (budget?.getResetDate())!)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        let days:String = (String(describing: components.day!))
        if (Int(days)! > 0){
            daysLeftLabel.text = days + " days until reset"
        } else{
            daysLeftLabel.text = "last day before reset"
        }
        
    }
}

