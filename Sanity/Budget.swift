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
    
    init(){
        
    }
}
