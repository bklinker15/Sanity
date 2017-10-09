//
//  Budget.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

class Budget {
    var name:String?
    var resetDate:Date?
    var lastReset:Date?
    var resetInterval:Int?
    var categories: [Category]?
    var totalBudget:Double?
    var budgetRemaining:Double?
    
    
    //Will definitely need to implement more, but for now this stub works
    init(dictionary:[String:Any]) {
        self.name = dictionary["name"] as? String
        self.budgetRemaining = dictionary["budgetRemaining"] as? Double
        self.totalBudget = dictionary["totalBudget"] as? Double
    }
    
    //Fill in rest of methods
    
    
}
