//
//  CategoryHistoryViewController.swift
//  Sanity
//
//  Created by Nicholas Kaimakis on 11/19/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

struct cellData{
    let period: String?
    let limit: Double?
    let remaining: Double?
}

class CategoryHistoryViewController: UITableViewController {
    var budgetName:String?
    var userEmail:String?
    var budget:Budget?
    var category:Category?
    var prevLimits = [Double]()
    var prevRemaining = [Double]()
    var arrayOfCellData = [cellData]()
    
    @IBOutlet var categoryHistoryTableView: UITableView!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryHistoryTableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryHistoryTableViewCell
        let row:Int = indexPath.row
        let periodText:String = arrayOfCellData[row].period!
        let spent: Double = arrayOfCellData[row].limit! - arrayOfCellData[row].remaining!
        let remaining: Double = arrayOfCellData[row].remaining!
        cell.setup(period: periodText, spent: spent, remaining: remaining)
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setHistory(){
        var currentPeriod: String
        var cellToAdd: cellData
        
        if let countPrevious:Int = self.prevLimits.count{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setFonts()
        self.title = category?.getName()
        self.categoryHistoryTableView.delegate = self
        self.categoryHistoryTableView.dataSource = self
        self.prevLimits = (self.category?.previousLimits)!
        self.prevRemaining = (self.category?.previousRemainings)!
        self.categoryHistoryTableView.rowHeight = 200

        setHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        setFonts()
        //
        //        fetchTransactions()
        //
        //        reload()
        //
        //        print(transactions.count)
        //        pieChartUpdate()
    }
}


