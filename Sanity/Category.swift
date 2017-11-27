//
//  Category.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/13/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

struct Category {
    var name:String
    var paymentMethods:[String]
    var spendingLimit: Double
    var amountSpent: Double
    var previousLimits:[Double]
    var previousRemainings:[Double]
    
    var dictionary:[String:Any] {
        return [
            "name":name,
            "paymentMethods":paymentMethods,
            "spendingLimit":spendingLimit,
            "amountSpent":amountSpent,
            "previousLimits":previousLimits,
            "previousRemainings":previousRemainings
        ]
    }
    
    func getName() -> String{
        return name
    }
    
    func getPaymentMethods() -> [String] {
        return paymentMethods
    }
    
    func getSpendingLimit() -> Double {
        return spendingLimit
    }
    
    func getAmountSpent() -> Double {
        return amountSpent
    }
    
    func getPrevLimits() -> [Double] {
        return previousLimits
    }
    
    func getPrevRemainings() -> [Double] {
        return previousRemainings
    }
}

extension Category : FirestoreSerializable {
    init?(dictionary: [String:Any]){
        guard let name = dictionary["name"] as? String,
            //let paymentMethods = dictionary["paymenthMethods"] as? [String]
            let spendingLimit = dictionary["spendingLimit"] as? Double,
            let amountSpent = dictionary["amountSpent"] as? Double,
            let previousLimits = dictionary["previousLimits"] as? [Double],
            let previousRemainings = dictionary["previousRemainings"] as? [Double]
            else {
                print("failed to deserialize category")
                return nil
        }
        
        self.init(name: name, paymentMethods: [""], spendingLimit: spendingLimit, amountSpent: amountSpent, previousLimits: previousLimits, previousRemainings: previousRemainings)
    }
}

