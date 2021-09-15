//
//  Phase3.swift
//
//
//  Created by Paul Mayer on 9/13/21.
//

import UIKit

//MARK: - Phase 3
internal extension ParseImage{

    /// - Transform image signature into vectors, It goes through a series of constructing and destructing pixels to form lines/vectors with only one neighboring pixel.
    func parseImagePhase3(){
        for currentPixel in imagePixelsArray{

            /* RESTORE South East Pixels
                ex#1:        *                  ex#2:    *
                            /                           /
                       * - @                           @
            */
            if currentPixel.color == .white,
               currentPixel.bottomLeftPix?.color == .black,
               currentPixel.pixelStatus == .deleted,
               currentPixel.leftPix?.color != .black,
               currentPixel.topPix?.color != .black,
               currentPixel.bottomRightPix?.color != .black,
               currentPixel.topLeftPix?.color != .black,
               currentPixel.topRightPix?.pixelStatus != .restoredRight,
               currentPixel.topPix?.pixelStatus != .maybeDeleteBottomLeft,
               currentPixel.topLeftPix?.topPix?.color != .black,
               currentPixel.topPix?.debugColor != .darkGreen,
               !(currentPixel.bottomLeftPix?.color == .black &&
                 currentPixel.bottomLeftPix?.bottomRightPix?.color == .black),
               !(currentPixel.leftPix?.color == .white &&
                 currentPixel.leftPix?.leftPix?.color == .black &&
                 currentPixel.bottomLeftPix?.color == .black){

                currentPixel.pixelStatus = .restoredLeft
                currentPixel.color = .black
                currentPixel.debugColor = .red
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.red.rawValue
            }

            /* RESTORE East Facing Pixels
                ex:    ... - @ - @ - *
            */
            if currentPixel.color == .white,
               currentPixel.pixelStatus == .deleted,
               currentPixel.leftPix?.pixelStatus == .restoredLeft,
               currentPixel.rightPix?.pixelStatus != .restoredLeft,
               currentPixel.topRightPix?.color != .black,
               currentPixel.bottomRightPix?.color != .black,
               currentPixel.bottomPix?.color != .black,
               currentPixel.topPix?.color != .black,
               currentPixel.topPix?.topPix?.color != .black,
               currentPixel.bottomPix?.pixelStatus != .deleted,
               !(currentPixel.rightPix?.color == .black &&
                currentPixel.rightPix?.bottomRightPix?.color == .black),
               currentPixel.topPix?.debugColor != .darkGreen{

                currentPixel.pixelStatus = .restoredLeft
                currentPixel.color = .black
                currentPixel.debugColor = .yellow
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.yellow.rawValue

            } else if currentPixel.color == .white,
              currentPixel.pixelStatus == .deleted,
              currentPixel.leftPix?.pixelStatus == .restoredLeft,
              currentPixel.topLeftPix?.color == .white,
              currentPixel.topPix?.color == .white,
              currentPixel.topRightPix?.color == .black,
              currentPixel.rightPix?.color == .black,
              currentPixel.bottomRightPix?.color == .white,
              currentPixel.bottomPix?.color == .white,
              currentPixel.bottomLeftPix?.color == .white{

                currentPixel.pixelStatus = .maybeRestoreLeft
                currentPixel.color = .white
                currentPixel.debugColor = .gray
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.gray.rawValue

            } else if currentPixel.color == .black,
             (currentPixel.pixelStatus == .normal ||
              currentPixel.pixelStatus == .maybeDeleteBottomLeft),
              currentPixel.leftPix?.pixelStatus == .maybeRestoreLeft,
              currentPixel.leftPix?.color == .white,
              currentPixel.topLeftPix?.color == .white,
              currentPixel.topPix?.color == .black,
              currentPixel.topRightPix?.color == .white,
              currentPixel.rightPix?.color == .white,
              currentPixel.bottomRightPix?.color == .white,
              currentPixel.bottomPix?.color == .white,
              currentPixel.bottomLeftPix?.color == .white{

                currentPixel.leftPix?.pixelStatus = .deleted
                currentPixel.leftPix?.color = .white
                currentPixel.leftPix?.debugColor = .orange
                imagePixelsPhase3[currentPixel.yPos][currentPixel.leftPix?.xPos ?? 0] = PixelColor.orange.rawValue
                currentPixel.color = .white
                currentPixel.debugColor = .orange
                currentPixel.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.orange.rawValue
            }

            /* RESTORE South East Pixels
                ex#1:    *                  ex#2:    *
                          \                           \
                           @ - *                       @
            */
            if currentPixel.color == .white,
               currentPixel.topLeftPix?.color == .black,
               currentPixel.pixelStatus == .deleted,
               currentPixel.topLeftPix?.pixelStatus != .restoredRight,
               currentPixel.topLeftPix?.pixelStatus != .restoredLeft,
               currentPixel.topLeftPix?.bottomLeftPix?.color != .black,
               currentPixel.topLeftPix?.topRightPix?.color != .black,
               currentPixel.leftPix?.color != .black,
               currentPixel.topRightPix?.color != .black,
               currentPixel.rightPix?.topRightPix?.color != .black,
               currentPixel.topLeftPix?.pixelStatus != .maybeDeleteBottomRight,
               currentPixel.topPix?.pixelStatus != .deleted,
               !(currentPixel.topLeftPix?.color == .black &&
                currentPixel.rightPix?.pixelStatus == .deleted &&
                currentPixel.leftPix?.pixelStatus == .deleted &&
                currentPixel.bottomLeftPix?.color == .black),
               !(currentPixel.topLeftPix?.color == .black &&
                currentPixel.rightPix?.pixelStatus == .deleted &&
                currentPixel.bottomRightPix?.color == .black &&
                currentPixel.leftPix?.pixelStatus == .deleted),
               !(currentPixel.topLeftPix?.color == .black &&
                currentPixel.topLeftPix?.topRightPix?.color == .black &&
                currentPixel.topLeftPix?.topPix?.topRightPix?.color == .black),
               !(currentPixel.neighbors.contains(where: {$0.pixelStatus == .restoredLeft})){

                currentPixel.pixelStatus = .restoredRight
                currentPixel.color = .black
                currentPixel.debugColor = .blue
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.blue.rawValue
            }

            /* DELETE Unused Pixel Connectors
                ex#1:    * - @          ex#2:    *
                             |                   |
                             *               * - @
            */
            if currentPixel.pixelStatus != .permanentlyDeleted,
               currentPixel.rightPix?.color == .black,
               (currentPixel.rightPix?.pixelStatus == .normal ||
                currentPixel.rightPix?.pixelStatus == .maybeDeleteBottomLeft ||
                currentPixel.rightPix?.pixelStatus == .maybeDeleteBottomRight),
               currentPixel.rightPix?.leftPix?.color == .black,
               (currentPixel.rightPix?.topPix?.color == .black ||
                currentPixel.rightPix?.bottomPix?.color == .black),
               (currentPixel.rightPix?.leftPix?.pixelStatus == .restoredLeft ||
                currentPixel.rightPix?.leftPix?.pixelStatus == .restoredRight){

                currentPixel.rightPix?.color = .white
                currentPixel.debugColor = .pink
                currentPixel.rightPix?.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.rightPix?.yPos ?? 0][currentPixel.rightPix?.xPos ?? 0] = PixelColor.pink.rawValue

                // DELETE potentially bad intersection result
                if currentPixel.rightPix?.bottomRightPix?.color == .black{
                    currentPixel.color = .white
                    currentPixel.pixelStatus = .deleted
                    imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.pink.rawValue
                }
                continue
            }

            /* DELETE Intersections with more than  pixels intersecting
                ex#1:    * - @ - *          ex#2:    *     *
                             |                         \  /
                             *                       * - @
            */
            if currentPixel.color == .black,
               currentPixel.neighbors.filter({$0.color == .black}).count >= 3{
                currentPixel.color = .white
                currentPixel.debugColor = .teal
                currentPixel.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.teal.rawValue
            }

            /* RESTORE East Facing Pixels
                ex:    * - @ - @ - . . .
            */
            if currentPixel.color == .white,
               currentPixel.pixelStatus == .deleted,
               currentPixel.leftPix?.pixelStatus == .restoredRight,
               currentPixel.rightPix?.pixelStatus != .restoredRight,
               currentPixel.topRightPix?.color != .black,
               currentPixel.bottomRightPix?.color != .black,
               currentPixel.bottomPix?.color != .black,
               currentPixel.topPix?.color != .black,
               currentPixel.topPix?.pixelStatus != .deleted,
               currentPixel.bottomLeftPix?.color != .black,
               currentPixel.bottomPix?.bottomPix?.color != .black,
               !(currentPixel.rightPix?.color == .black &&
                currentPixel.rightPix?.topRightPix?.color == .black){

                 currentPixel.pixelStatus = .restoredRight
                 currentPixel.color = .black
                currentPixel.debugColor = .green
                 imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.green.rawValue

            } else if currentPixel.color == .white,
                currentPixel.pixelStatus == .deleted,
                currentPixel.leftPix?.pixelStatus == .restoredRight,
                currentPixel.topLeftPix?.color == .white,
                currentPixel.topPix?.color == .white,
                currentPixel.topRightPix?.color == .white,
                currentPixel.rightPix?.color == .black,
                currentPixel.bottomRightPix?.color == .black,
                currentPixel.bottomPix?.color == .white,
                currentPixel.bottomLeftPix?.color == .white{

                currentPixel.pixelStatus = .maybeRestoreRight
                currentPixel.color = .white
                currentPixel.debugColor = .gray
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.gray.rawValue

            } else if currentPixel.color == .black,
               (currentPixel.pixelStatus == .normal ||
                currentPixel.pixelStatus == .maybeDeleteBottomRight),
                currentPixel.leftPix?.pixelStatus == .maybeRestoreRight,
                currentPixel.leftPix?.color == .white,
                currentPixel.topLeftPix?.color == .white,
                currentPixel.topPix?.color == .white,
                currentPixel.topRightPix?.color == .white,
                currentPixel.rightPix?.color == .white,
                currentPixel.bottomRightPix?.color == .white,
                currentPixel.bottomPix?.color == .black,
                currentPixel.bottomLeftPix?.color == .white{

                currentPixel.leftPix?.pixelStatus = .restoredRight
                currentPixel.leftPix?.color = .black
                currentPixel.leftPix?.color = .green
                imagePixelsPhase3[currentPixel.yPos][currentPixel.leftPix?.xPos ?? currentPixel.xPos - 1] = PixelColor.green.rawValue
                currentPixel.color = .white
                currentPixel.debugColor = .orange
                currentPixel.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.orange.rawValue
                if currentPixel.bottomPix?.color == .black{
                    currentPixel.bottomPix?.pixelStatus = .maybeDeleteBottomLeft
                }
            }

            /* DELETE Bottom Pixel Connector
                ex:    *   *
                        \ /
                         @
            */
            if currentPixel.color == .black,
               currentPixel.topLeftPix?.color == .black,
               currentPixel.bottomLeftPix?.color == .white,
               currentPixel.leftPix?.color == .white,
               currentPixel.topRightPix?.color == .black,
               currentPixel.bottomRightPix?.color == .white,
               currentPixel.rightPix?.color == .white,
               currentPixel.topPix?.color == .white,
               currentPixel.bottomPix?.color == .white{

                currentPixel.color = .white
                currentPixel.debugColor = .darkBlue
                currentPixel.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.darkBlue.rawValue
            }

            /* DELETE Top Pixel Connector
                ex:        @
                          / \
                         *   *
            */
            if currentPixel.color == .black,
               currentPixel.topLeftPix?.color == .white,
               currentPixel.bottomLeftPix?.color == .black,
               currentPixel.leftPix?.color == .white,
               currentPixel.topRightPix?.color == .white,
               currentPixel.bottomRightPix?.color == .black,
               currentPixel.rightPix?.color == .white,
               currentPixel.topPix?.color == .white,
               currentPixel.bottomPix?.color == .white{

                currentPixel.color = .white
                currentPixel.debugColor = .purple
                currentPixel.pixelStatus = .deleted
                imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.purple.rawValue
            }

            /* DELETE West Pixel Connector
                ex:                     ex#2:
                         *                   *
                          \                   \
                           *                   @
                           |                  /
                           @                 *
                          /
                         *
            */
            if currentPixel.color == .black,
               currentPixel.bottomRightPix?.color == .black {
                currentPixel.bottomRightPix?.pixelStatus = .maybeDeleteBottomLeft
            }

            if currentPixel.color == .black,
               currentPixel.pixelStatus == .maybeDeleteBottomLeft{

                if currentPixel.bottomLeftPix?.color == .black,
                   currentPixel.bottomPix?.color == .white,
                   currentPixel.bottomRightPix?.color == .white,
                   currentPixel.leftPix?.color == .white,
                   currentPixel.topLeftPix?.color == .white,
                   currentPixel.rightPix?.color == .white,
                   currentPixel.topRightPix?.color == .white{

                    currentPixel.color = .white
                    currentPixel.debugColor = .lightGreen
                    currentPixel.pixelStatus = .deleted
                    imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.lightGreen.rawValue
                }

                if currentPixel.bottomRightPix?.color == .white,
                   currentPixel.bottomPix?.color == .black,
                   currentPixel.bottomLeftPix?.color == .white,
                   currentPixel.leftPix?.color == .white,
                   currentPixel.rightPix?.color == .white,
                   currentPixel.topRightPix?.color == .white{

                    currentPixel.bottomPix?.pixelStatus = .maybeDeleteBottomLeft
                }
            }

            /* DELETE West Pixel Connector
                ex:                     ex#2:
                             *                   *
                            /                   /
                           *                    @
                           |                    \
                           @                     *
                            \
                             *
            */
            if currentPixel.color == .black,
               currentPixel.bottomLeftPix?.color == .black {
                currentPixel.bottomLeftPix?.pixelStatus = .maybeDeleteBottomRight
            }

            if currentPixel.color == .black,
               currentPixel.pixelStatus == .maybeDeleteBottomRight{

                if currentPixel.bottomRightPix?.color == .black,
                   currentPixel.bottomPix?.color == .white,
                   currentPixel.bottomLeftPix?.color == .white,
                   currentPixel.leftPix?.color == .white,
                   currentPixel.topLeftPix?.color == .white,
                   currentPixel.rightPix?.color == .white{

                    currentPixel.color = .white
                    currentPixel.debugColor = .darkGreen
                    currentPixel.pixelStatus = .deleted
                    imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.darkGreen.rawValue

                } else if currentPixel.bottomRightPix?.color == .white,
                          currentPixel.bottomPix?.color == .black,
                          currentPixel.bottomLeftPix?.color == .white,
                          currentPixel.leftPix?.color == .white,
                          currentPixel.topLeftPix?.color == .white,
                          currentPixel.rightPix?.color == .white {

                    currentPixel.bottomPix?.pixelStatus = .maybeDeleteBottomRight
                }
            }

            /* DELETE Intersections
                ex:
                             *
                              \
                           * - @ - *
                               |
                               *

            */
            let coloredPixelNeighbors = currentPixel.neighbors.filter({$0.color == .black})
            let notColoredPixelNeighbors = currentPixel.neighbors.filter({$0.color == .white && $0.pixelStatus == .deleted})
            if coloredPixelNeighbors.count >= 2,
               notColoredPixelNeighbors.count >= 4,
               currentPixel.color == .black {
                let intsectingNeighbors = checkNeighborsForIntersection(currentPixel: currentPixel)
                if intsectingNeighbors.count >= 3,
                   intsectingNeighbors.filter({$0.pixelStatus == .restoredRight}).count < 2{
                    currentPixel.color = .white
                    currentPixel.debugColor = .gold
                    currentPixel.pixelStatus = .deleted
                    imagePixelsPhase3[currentPixel.yPos][currentPixel.xPos] = PixelColor.gold.rawValue
                    for pixel in intsectingNeighbors{
                        pixel.color = .white
                        pixel.debugColor = .grayBlue
                        currentPixel.pixelStatus = .permanentlyDeleted
                        imagePixelsPhase3[pixel.yPos][pixel.xPos] = PixelColor.grayBlue.rawValue
                    }
                }
            }
        }
    }
    
    
    /// Looks at the second level of neighboring pixels and if more than three exist there is most likley an intersection.
    /// - Parameter currentPixel: Current pixel,  used to grab it's neighboring pixels at the second level.
    /// - Returns: The collection of neighboring pixels at the second level.
    func checkNeighborsForIntersection(currentPixel: ImagePixel) -> [ImagePixel]{
        var intersectingPixels: [ImagePixel] = []
        if let pix0 = currentPixel.topLeftPix?.topLeftPix, pix0.color == .black{
            intersectingPixels.append(pix0)
        }
        if let pix1 = currentPixel.topPix?.topLeftPix, pix1.color == .black{
            intersectingPixels.append(pix1)
        }
        if let pix2 = currentPixel.topPix?.topPix, pix2.color == .black{
            intersectingPixels.append(pix2)
        }
        if let pix3 = currentPixel.topPix?.topRightPix, pix3.color == .black{
            intersectingPixels.append(pix3)
        }
        if let pix4 = currentPixel.topRightPix?.topRightPix, pix4.color == .black{
            intersectingPixels.append(pix4)
        }
        if let pix5 = currentPixel.rightPix?.topRightPix, pix5.color == .black{
            intersectingPixels.append(pix5)
        }
        if let pix6 = currentPixel.rightPix?.rightPix, pix6.color == .black{
            intersectingPixels.append(pix6)
        }
        if let pix7 = currentPixel.rightPix?.bottomRightPix, pix7.color == .black{
            intersectingPixels.append(pix7)
        }
        if let pix8 = currentPixel.bottomRightPix?.bottomRightPix, pix8.color == .black{
            intersectingPixels.append(pix8)
        }
        if let pix9 = currentPixel.bottomPix?.bottomRightPix, pix9.color == .black{
            intersectingPixels.append(pix9)
        }
        if let pix10 = currentPixel.bottomPix?.bottomPix, pix10.color == .black{
            intersectingPixels.append(pix10)
        }
        if let pix11 = currentPixel.bottomPix?.bottomLeftPix, pix11.color == .black{
            intersectingPixels.append(pix11)
        }
        if let pix14 = currentPixel.bottomLeftPix?.bottomLeftPix, pix14.color == .black{
            intersectingPixels.append(pix14)
        }
        if let pix15 = currentPixel.leftPix?.bottomLeftPix, pix15.color == .black{
            intersectingPixels.append(pix15)
        }
        if let pix16 = currentPixel.leftPix?.leftPix, pix16.color == .black{
            intersectingPixels.append(pix16)
        }
        if let pix17 = currentPixel.leftPix?.topLeftPix, pix17.color == .black{
            intersectingPixels.append(pix17)
        }
        
        //TODO: Fix this. . . This is a really ugly solution and needs a better approach to check whether one list contains an elemnt from another list.
        var tempIntersectingPixels = intersectingPixels
        for pixel in intersectingPixels{
            let neighbors = pixel.neighbors
            for (index2, pixel2) in intersectingPixels.enumerated(){
                if neighbors.contains(where: {$0.xPos == pixel2.xPos && $0.yPos == pixel2.yPos}) {
                    let range = 0..<tempIntersectingPixels.count
                    if range.contains(index2){
                        tempIntersectingPixels.remove(at: index2)
                    }
                }
            }
        }
        return tempIntersectingPixels
    }
}





