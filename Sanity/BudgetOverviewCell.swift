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
    @IBOutlet weak var progressBar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
