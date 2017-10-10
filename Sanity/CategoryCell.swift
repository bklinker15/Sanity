//
//  CategoryCell.swift
//  Sanity
//
//  Created by Brooks Klinker on 10/9/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNameTextField: UITextField!
    
    @IBOutlet weak var limitTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(){
        categoryNameTextField.placeholder = "Category"
        limitTextField.placeholder = "Limit"
        limitTextField.keyboardType = UIKeyboardType.numberPad
    }
}
