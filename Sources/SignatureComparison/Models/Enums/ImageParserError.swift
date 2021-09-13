//
//  ImageParserError.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation


public enum ImageParserError: Error {
    case invalidImageSupplied(String)
    case unableToParseImage(String)
}
