//
//  BudgetHistoryViewController.swift
//  Sanity
//
//  Created by Nicholas Kaimakis on 10/22/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Charts

class BudgetHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var budgetName:String?
    var userEmail:String?
    var budget:Budget?
    var prevLimits = [Double]()
    var prevRemaining = [Double]()
    var arrayOfCellData = [cellData]()
    
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var HistoryTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfCellData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HistoryTableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryTableViewCell
        let row:Int = indexPath.row
        let periodText:String = arrayOfCellData[row].period!
        let spent: Double = arrayOfCellData[row].limit! - arrayOfCellData[row].remaining!
        let remaining: Double = arrayOfCellData[row].remaining!
        
        cell.setup(period: periodText, spent: spent, remaining: remaining)
        return cell
    }
    
    
    func setHistory(){
        var currentPeriod: String
        var cellToAdd: cellData
        
        if let countPrevious:Int = self.prevLimits.count{
            //add placeholder if no history exists
            if(countPrevious == 0){
                self.placeholder.isHidden = false
                self.placeholder.text = "You have no history to display! Start tracking!"
                self.placeholder.font = UIFont(name: "DidactGothic-Regular", size: 20)
                self.HistoryTableView.isHidden = true
            }
            else{
                self.placeholder.isHidden = true
                self.HistoryTableView.isHidden = false
                for i in 0..<countPrevious {
                    if i == 0{
                        currentPeriod = "last period"
                    } else if i == 1 {
                        currentPeriod = "1 period ago"
                    } else {
                        currentPeriod = String(i) + " periods ago"
                    }
                    
                    cellToAdd = cellData(period: currentPeriod, limit: self.prevLimits[i], remaining: self.prevRemaining[i])
                    arrayOfCellData.append(cellToAdd)
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HistoryTableView.delegate = self
        self.HistoryTableView.dataSource = self
        self.nameLabel.text = "Budget History( " + (budget?.name)! + ")"
        self.prevLimits = (self.budget?.previousBudgetLimits)!
        self.prevRemaining = (self.budget?.previousBudgetRemains)!
        self.nameLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        setHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

