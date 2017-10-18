//
//  BudgetOverviewCell.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/7/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class BudgetOverviewCell: UITableViewCell {

    @IBOutlet weak var budgetName: UILabel!
    @IBOutlet weak var daysUntilReset: UILabel!
    @IBOutlet weak var budgetRemaining: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setFonts()
        // Initialization code
    }
    func setFonts(){
        budgetName.font = UIFont(name: "DidactGothic-Regular", size: 20)
        daysUntilReset.font = UIFont(name: "DidactGothic-Regular", size: 20)
        budgetRemaining.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
