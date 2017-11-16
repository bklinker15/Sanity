//
//  TransactionCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 15/11/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit


class TransactionCell: UITableViewCell{
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    func setUp(date:String, amount:String, budget:String, memo:String){
        setFont()
        dateLabel.text = date
        amountLabel.text = amount
        budgetLabel.text = budget
        memoLabel.text = memo
        
    }
    
    
    func setFont(){
      dateLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
        amountLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
        budgetLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
        memoLabel.font = UIFont(name: "DidactGothic-Regular", size: 18)
    }
}
