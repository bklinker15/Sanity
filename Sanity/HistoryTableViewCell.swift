//
//  HistoryTableViewCell.swift
//  Sanity
//
//  Created by Nicholas Kaimakis on 10/22/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyCellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(){
        self.historyCellTitle.text = " periods ago"
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setFont()
    }
    
    func setFont(){
         historyCellTitle.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }
}
