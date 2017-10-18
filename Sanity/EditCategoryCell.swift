//
//  EditCategoryCell.swift
//  Sanity
//
//  Created by Katie Wasserman on 18/10/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class EditCategoryCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var catLimitField: UITextField!
    @IBOutlet weak var catNameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setup(){
        
        setFont()
    }
    @IBOutlet weak var editCategory: UIButton!
    
    @IBAction func deleteCategory(_ sender: Any) {
    }
    func setFont(){
       
    }

}
