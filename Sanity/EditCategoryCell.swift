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

    @IBOutlet weak var catNameField: UITextField!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setup(catName:String, catLimit: String){
        catNameField.text = catName
        catLimitField.text = catLimit
        
        catNameField.isUserInteractionEnabled = false
        catLimitField.isUserInteractionEnabled = false
        
        setFont()
    }

    @IBAction func editCategory(_ sender: UIButton) {
        catNameField.isUserInteractionEnabled = true
        catLimitField.isUserInteractionEnabled = true
    }
    

    func setFont(){
        catNameField.font = UIFont(name: "DidactGothic-Regular", size: 20)
        catLimitField.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }

}
