//
//  AddTransactionCell.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/15/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class AddTransactionCell: UITableViewCell {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var amountSpent: UITextField!
    @IBOutlet weak var optionalMemo: UITextField!
    
    var selectedCategoryIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
