//
//  Budget.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

//Made this a struct instead of a class to leverage convenience intializer
//Can change - Jordan
struct Budget {
    var name:String?
    var resetDate:Date?
    var lastReset:Date?
    var resetInterval:Int?
    //I don't think we need categories TBH, will just query Firebase
    var categories: [Category]?
    var totalBudget:Double?
    var budgetRemaining:Double?
    
    //Fill in rest of methods
    
    
}

extension Budget : FirestoreSerializable {
    init?(dictionary: [String:Any]){
        guard let name = dictionary["name"] as? String,
            let budgetRemaining = dictionary["budgetRemaining"] as? Double,
            let totalBudget = dictionary["totalBudget"] as? Double,
            let lastReset = dictionary["lastReset"]  as? Date,
            let resetDate = dictionary["resetDate"]  as? Date,
            let resetInterval = dictionary["resetInterval"] as? Int else {return nil}
        
        self.init(name: name, resetDate: resetDate, lastReset: lastReset,
                  resetInterval: resetInterval, categories: [],
                  totalBudget: totalBudget, budgetRemaining: budgetRemaining)
    }
}
