//
//  CategoryCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 10/16/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class CategoryBudgetCell: UITableViewCell {
    @IBOutlet weak var catProg: UIProgressView!
    
    @IBOutlet weak var catRemainingLabel: UILabel!
    @IBOutlet weak var catSpentLabel: UILabel!
    @IBOutlet weak var catLimitLabel: UILabel!
    @IBOutlet weak var catNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    public func setup(name:String, prog:Float, limit:String, spent:String, left:String){
        catNameLabel.text = name
        catLimitLabel.text = "Category Limit: " + limit
        catSpentLabel.text = "Funds spent in category: " + spent
        catRemainingLabel.text = "Remaining funds in category: " + left
        catProg.progress = prog
        setFonts()
    }
    func setFonts(){
        catNameLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        catLimitLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        catSpentLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        catRemainingLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
        
    }
    
}
