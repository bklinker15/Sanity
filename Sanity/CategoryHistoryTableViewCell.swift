//
//  CategoryHistoryTableViewCell.swift
//  
//
//  Created by Nicholas Kaimakis on 11/20/17.
//

import UIKit
import Charts

class CategoryHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(period:String, spent:Double, remaining:Double){
        periodLabel.text = period
        let spentEntry = PieChartDataEntry(value: Double(spent), label: "Spent")
        let remainingEntry = PieChartDataEntry(value: Double(remaining), label: "Remaining")
        let dataSet = PieChartDataSet(values: [spentEntry, remainingEntry], label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueColors = [UIColor.black]
        dataSet.entryLabelFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        dataSet.valueFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = "" //period
        //pieChart.chartDescription?.font = UIFont(name: "DidactGothic-Regular", size: 10)!
        pieChart.entryLabelFont = UIFont(name: "DidactGothic-Regular", size: 10)!
        
        //This must stay at end
        pieChart.notifyDataSetChanged()
        setFonts()
    }
    func setFonts(){
        periodLabel.font = UIFont(name: "DidactGothic-Regular", size: 15)
    }

}
