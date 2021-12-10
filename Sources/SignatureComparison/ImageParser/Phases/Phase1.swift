//
//  Phase1.swift
//
//
//  Created by Paul Mayer on 9/13/21.
//

import UIKit

//MARK: - Phase 1
internal extension ParseImage{
    
    /// - Converts the image to black and white pixels only. Also initializes key variables for image parser. Only active pixels continue to phases 2-4.
    /// - Parameters:
    ///   - cgImage: The image signature in Core Graphic format
    ///   - bytes: Pointer to the image data
    func parseImagePhase1(_ cgImage: CGImage, _ bytes: UnsafePointer<UInt8>){
        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        let black = PixelColor.black
        let white = PixelColor.white
        let width = cgImage.width
        let height = cgImage.height
        let xBoundary = width - 1
        let yBoundary = height - 1
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                //check with conditions to make sure it is a black pixel
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                
                debugPrint("Position - x:\(x)  y:\(y) - R: \(bytes[offset])")
                debugPrint("Position - x:\(x)  y:\(y) - G: \(bytes[offset + 1])")
                debugPrint("Position - x:\(x)  y:\(y) - B: \(bytes[offset + 2])")
                debugPrint("Position - x:\(x)  y:\(y) - A: \(bytes[offset + 3])")
                
                if x == 0 || y == 0 || y == yBoundary || x == xBoundary {
                    let newPixel = ImagePixel(white, xPos: x, yPos: y)
                    pixelImageMap[PixelCoordinate(x: x, y: y)] = newPixel
                    continue
                }
                
                // bytes[offset] == r
                // bytes[offset + 1] == g
                // bytes[offset + 2] == b
                // bytes[offset + 3] == a
                if !(bytes[offset] == 255 &&
                     bytes[offset + 1] == 255 &&
                     bytes[offset + 2] == 255 &&
                     bytes[offset + 3] == 255) &&
                    !(bytes[offset] == 0 &&
                         bytes[offset + 1] == 0 &&
                         bytes[offset + 2] == 0 &&
                         bytes[offset + 3] == 0){
                    let newPixel = ImagePixel(black, xPos: x, yPos: y)
                    imagePixelsArray.append(newPixel)
                    pixelImageMap[PixelCoordinate(x: x, y: y)] = newPixel
                    imagePixelsPhase1[y][x] = black.rawValue
                }
            }
        }
    }
}
