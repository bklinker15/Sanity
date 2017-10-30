//
//  Budget.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/8/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

struct Budget {
    var name:String
    var resetDate:Date
    var lastReset:Date
    var resetInterval:Int
    var totalBudget:Double
    var budgetRemaining:Double
    var previousBudgetRemains:[Double]
    var previousBudgetLimits:[Double]
    var notificationThreshold:Double
    
    var dictionary:[String:Any] {
        return [
            "name":name,
            "budgetRemaining":budgetRemaining,
            "totalBudget":totalBudget,
            "lastReset":lastReset,
            "resetDate":resetDate,
            "resetInterval":resetInterval,
            "previousBudgetRemains" : previousBudgetRemains,
            "previousBudgetLimits": previousBudgetLimits,
            "notificationThreshold": notificationThreshold
        ]
    }
    
    func getName() -> String {
        return name
    }
    
    func getResetDate() -> Date {
        return resetDate
    }
    
    func getLastReset() -> Date {
        return lastReset
    }
    
    func getResetInterval() -> Int {
        return resetInterval
    }
    
    func getTotalBudget() -> Double {
        return totalBudget
    }
    
    func getBudgetRemaining() -> Double {
        return budgetRemaining
    }
    func getNotificationThreshold() -> Double {
        return notificationThreshold
    }
    
    /* Returns last six budget limits starting with the least recent */
    func getPreviousSixBudgetLimits() ->  [Double] {
        if previousBudgetLimits.count <= 6{
            return previousBudgetLimits
        }
        
        let n = previousBudgetLimits.count
        var ret = [Double]()
        
        for i in (n-6)...(n-1){
            ret.append(previousBudgetLimits[i])
        }
        
        return ret
    }
    
    /* Returns last six budget remains starting with the least recent */
    func getPreviousSixBudgetRemains() -> [Double] {
        if previousBudgetRemains.count <= 6{
            return previousBudgetRemains
        }
        
        let n = previousBudgetRemains.count
        var ret = [Double]()
        
        for i in (n-6)...(n-1){
            ret.append(previousBudgetRemains[i])
        }
        
        return ret
    }
}

extension Budget : FirestoreSerializable {
    init?(dictionary: [String:Any]){
        guard let name = dictionary["name"] as? String,
            let budgetRemaining = dictionary["budgetRemaining"] as? Double,
            let totalBudget = dictionary["totalBudget"] as? Double,
            let lastReset = dictionary["lastReset"]  as? Date,
            let resetDate = dictionary["resetDate"]  as? Date,
            let resetInterval = dictionary["resetInterval"] as? Int,
            let notificationThreshold = dictionary["notificationThreshold"]  as? Double,
            let previousBudgetRemains = dictionary["previousBudgetRemains"] as? [Double],
            let previousBudgetLimits = dictionary["previousBudgetLimits"] as? [Double] else {return nil}
        
        self.init(name: name, resetDate: resetDate, lastReset: lastReset,
                  resetInterval: resetInterval,
                  totalBudget: totalBudget, budgetRemaining: budgetRemaining, previousBudgetRemains: previousBudgetRemains, previousBudgetLimits: previousBudgetLimits, notificationThreshold: notificationThreshold)
    }
}
