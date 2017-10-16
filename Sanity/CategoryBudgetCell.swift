//
//  CategoryCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 10/16/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class CategoryBudgetCell: UITableViewCell {
    

    @IBOutlet weak var catProgress: UIProgressView!
    
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catLimit: UILabel!
    @IBOutlet weak var catFundsSpent: UILabel!
    @IBOutlet weak var catRemainingFunds: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setup(name:String, prog:Float, limit:String, spent:String, left:String){
        catName.text = name
        catLimit.text = limit
        catFundsSpent.text = spent
        catRemainingFunds.text = left
        catProgress.progress = prog
    }
}
