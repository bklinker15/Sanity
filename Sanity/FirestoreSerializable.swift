//
//  FirestoreSerializable.swift
//  Sanity
//
//  Created by Jordan Coppert on 10/9/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import Foundation

protocol FirestoreSerializable {
    init?(dictionary:[String:Any])
}

