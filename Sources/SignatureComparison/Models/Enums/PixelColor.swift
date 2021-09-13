//
//  PixelColor.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

enum PixelColor: UInt32{
    case clear = 0
    case white = 0b11111111111111111111111111111111 //UInt32.max
    case black = 255
    case red = 0b11111111000000000000000011111111
    case green = 0b00000000111111110000000011111111
    case blue = 0b00000000000000001111111111111111
    case yellow = 0b11111111111111110000000011111111
    case pink = 0b11111111000000001111111111111111
    case teal = 0b00000000111111111111111111111111
    case orange = 0xFFA500FF
    case purple = 0x6A0DADFF
    case lightGreen = 0x90EE90FF
    case gold = 0xDAA520FF
    case brown = 0x964B00FF
    case gray = 0x808080FF
    case grayBlue = 0x43A6C6FF
    case darkBlue = 0x000C66FF
    case darkGreen = 0x024b30FF
    case knowInkYellow = 0xC5D428FF
}
