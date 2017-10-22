//
//  BudgetHistoryViewController.swift
//  Sanity
//
//  Created by Nicholas Kaimakis on 10/22/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit

class BudgetHistoryViewController: UIViewController {
    var budgetName:String?
    var userEmail:String?
    var budget:Budget?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setFonts()
        nameLabel.text = budget?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFonts(){
        //budgetNameLabel.font = UIFont(name: "DidactGothic-Regular", size: 20)
    }

}
