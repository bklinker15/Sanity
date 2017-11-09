//
//  CategoryCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 10/16/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import Charts

class CategoryBudgetCell: UITableViewCell {

    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    public func setup(name:String, spent:Double, remaining:Double){
        catLabel.text = name
        catLabel.font = UIFont(name: "DidactGothic-Regular", size: 15)
        let spentEntry = PieChartDataEntry(value: Double(spent), label: "Dollars Spent")
        let remainingEntry = remaining < 0 ? PieChartDataEntry(value: 0.0, label: "Dollars Remaining") : PieChartDataEntry(value: Double(remaining), label: "Dollars Remaining")
        let dataSet = PieChartDataSet(values: [spentEntry, remainingEntry], label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        dataSet.entryLabelFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        dataSet.valueFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = ""
        //pieChart.chartDescription?.font = UIFont(name: "DidactGothic-Regular", size: 15)!
        pieChart.entryLabelFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        
        //This must stay at end
        pieChart.notifyDataSetChanged()
    }
}
