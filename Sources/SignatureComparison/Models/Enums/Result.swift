//
//  Result.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(ImageParserError)
}
