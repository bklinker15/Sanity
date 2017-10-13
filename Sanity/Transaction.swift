//
//  Transaction.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/13/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

struct Transaction {
    //In their requirements they said they wanted an optional memo I believe
    var memo:String
    var linkedBudgets:[String]
    var paymentMethod:String
    var amount:Double
    var timestamp:Date
    
    var dictionary:[String:Any] {
        return [
            "memo":memo,
            "linkedBudgets":linkedBudgets,
            "paymentMethod":paymentMethod,
            "amount":amount,
            "timestamp":timestamp
        ]
    }
}

extension Transaction : FirestoreSerializable {
    init?(dictionary: [String:Any]){
        guard let memo = dictionary["memo"] as? String,
            let linkedBudgets = dictionary["linkedBudgets"] as? [String],
            let paymentMethods = dictionary["paymenthMethods"] as? String,
            let amount = dictionary["amount"] as? Double,
            let timestamp = dictionary["timestamp"] as? Date else {return nil}
        
        self.init(memo: memo, linkedBudgets: linkedBudgets, paymentMethod:
            paymentMethods, amount: amount, timestamp: timestamp)
    }
}
