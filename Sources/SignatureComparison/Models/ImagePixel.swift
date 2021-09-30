//
//  ImagePixel.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

class ImagePixel{
    
    var color: PixelColor = .clear
    var debugColor: PixelColor?
    var xPos: Int
    var yPos: Int
    var pixelStatus: PixelStatus = .normal
    var neighbors: [ImagePixel] = []
    
    var topLeftPix: ImagePixel?{
        didSet{
            if let pixel = topLeftPix{
                neighbors.append(pixel)
            }
        }
    }
    var topPix: ImagePixel?{
        didSet{
            if let pixel = topPix{
                neighbors.append(pixel)
            }
        }
    }
    var topRightPix: ImagePixel?{
        didSet{
            if let pixel = topRightPix{
                neighbors.append(pixel)
            }
        }
    }
    var rightPix: ImagePixel?{
        didSet{
            if let pixel = rightPix{
                neighbors.append(pixel)
            }
        }
    }
    var bottomRightPix: ImagePixel?{
        didSet{
            if let pixel = bottomRightPix{
                neighbors.append(pixel)
            }
        }
    }
    var bottomPix: ImagePixel?{
        didSet{
            if let pixel = bottomPix{
                neighbors.append(pixel)
            }
        }
    }
    var bottomLeftPix: ImagePixel?{
        didSet{
            if let pixel = bottomLeftPix{
                neighbors.append(pixel)
            }
        }
    }
    var leftPix: ImagePixel? {
        didSet{
            if let pixel = leftPix{
                neighbors.append(pixel)
            }
        }
    }
    
    init(_ color: PixelColor, xPos: Int, yPos: Int) {
        self.color = color
        self.xPos = xPos
        self.yPos = yPos
    }
    
    func hasAtLeastOneNeighborProcessed() -> ImagePixel?{
        return neighbors.first(where: {$0.pixelStatus == .processed})
    }
    
    func canBeStartPixel() -> Bool{
        if neighbors.filter({$0.color == .black}).count == 1{
            return true
        }
        return false
    }
}

