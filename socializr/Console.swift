//
//  Console.swift
//  socializr
//
//  Created by Max Saienko on 5/5/15.
//  Copyright (c) 2015 Max Saienko. All rights reserved.
//

import Foundation

class Console {
    class func log(message: AnyObject, function: String = __FUNCTION__) -> Void {
        #if DEBUG
            println("\(function): \(message)")
        #endif
    }
}