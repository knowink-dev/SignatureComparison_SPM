//
//  PixelVector.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

class PixelVector{
    var pixelPath: [ImagePixel] = []
    var angle: Double = 0.0
    var processed = false
    var minXPos: Int!
    var startPixel: ImagePixel!
    var endPixel: ImagePixel!{
        didSet{
            let firstPixel: ImagePixel!
            let secondPixel: ImagePixel!
            if startPixel.xPos <= endPixel.xPos{
                firstPixel = startPixel
                secondPixel = endPixel
            } else {
                firstPixel = endPixel
                secondPixel = startPixel
            }
            if secondPixel.xPos > firstPixel.xPos{
                angle = (atan(((Double(secondPixel.yPos) - Double(firstPixel.yPos))) / (Double(firstPixel.xPos) - Double(secondPixel.xPos))) * (180 / Double.pi)) + 90
            } else{
                angle = (atan((Double(secondPixel.yPos) - Double(firstPixel.yPos)) / (Double(secondPixel.xPos) - Double(firstPixel.xPos))) * (180 / Double.pi)) + 90
            }
            minXPos = (startPixel.xPos < endPixel.xPos) ? startPixel.xPos : endPixel.xPos
        }
    }
}
