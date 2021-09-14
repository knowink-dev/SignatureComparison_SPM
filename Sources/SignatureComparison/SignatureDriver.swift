//
//  SignatureDriver.swift
//  MetalAndImages
//
//  Created by Paul Mayer on 8/16/21.
//

import Foundation
import UIKit


public class SignatureComparison{
    
    
    public class func compare(_ primarySignature: UIImage,
                                  _ secondarySignature: UIImage,
                                  _ handler: @escaping (_ percentage: Double?,
                                                        _ error: String?) -> Void) {
        compareSignatures(primarySignature,
                          secondarySignature,
                          false) { percentage,
                                   breakingErrors,
                                   parsedImageObjs in
            if breakingErrors != nil{
                handler(percentage, breakingErrors)
            } else {
                let silentErrors = parsedImageObjs.map({$0.map({$0.silentErrors.joined(separator: ",")}).joined(separator: "|")})
                handler(percentage, silentErrors)
            }
        }
    }
    
    class func compareSignatures(_ primarySignature: UIImage,
                           _ secondarySignature: UIImage,
                           _ isDebugMode: Bool = false,
                           _ handler: @escaping (_ percentage: Double?,
                                                 _ breakingError: String?,
                                                 _ imageObj: [ParsedImage]?) -> Void) {
        let parseImgQueue = OperationQueue()
        parseImgQueue.maxConcurrentOperationCount = 2
        var primaryImgObj: ParsedImage?
        var secondaryImgObj: ParsedImage?
           
        DispatchQueue.global().async {
            let primaryBlock = BlockOperation{
                let imgParser = ParseImage()
                let result = imgParser.parseImage(inputImage: primarySignature,
                                                            runInDebugMode: isDebugMode)
                switch result {
                case .success(let data):
                    primaryImgObj = data
                case .failure(let error):
                    switch error {
                    case .invalidImageSupplied(let errorMessage):
                        handler(nil, "INVALID PRIMARY IMAGE SUPPLIED: \(errorMessage)", nil)
                        parseImgQueue.cancelAllOperations()
                    case .unableToParseImage(let errorMessage):
                        handler(nil,"PRIMARY IMAGE PARSING ERROR: \(errorMessage)", nil)
                        parseImgQueue.cancelAllOperations()
                    }
                }
            }
            
            let secondaryBlock = BlockOperation{
                let imgParser = ParseImage()
                let result = imgParser.parseImage(inputImage: secondarySignature,
                                                            runInDebugMode: isDebugMode)
                switch result {
                case .success(let data):
                    secondaryImgObj = data
                case .failure(let error):
                    switch error {
                    case .invalidImageSupplied(let errorMessage):
                        handler(nil, "INVALID SECONDARY IMAGE SUPPLIED: \(errorMessage)", nil)
                        parseImgQueue.cancelAllOperations()
                    case .unableToParseImage(let errorMessage):
                        handler(nil,"SECONDARY IMAGE PARSING ERROR: \(errorMessage)", nil)
                        parseImgQueue.cancelAllOperations()
                    }
                }
            }
            parseImgQueue.addOperations([primaryBlock, secondaryBlock], waitUntilFinished: true)

            if let primaryImage = primaryImgObj, let secondaryImage = secondaryImgObj{
                var overallPercentage = 0.0
                if primaryImage.vectors.count >= secondaryImage.vectors.count{
                    if primaryImage.vectors.count > 0{
                        overallPercentage = computePercentage(numImg: secondaryImage, denImg: primaryImage)
                    } else {
                        handler(nil, "ERROR: Unable to Parse Image. No lines were recognized for the Primary Image supplied.", nil)
                    }
                } else {
                    if secondaryImage.vectors.count > 0{
                        overallPercentage = computePercentage(numImg: primaryImage, denImg: secondaryImage)
                    } else {
                        handler(nil, "ERROR: Unable to Parse Image. No lines were recognized for the Secondary Image supplied.", nil)
                    }
                }
                handler(overallPercentage, nil, [primaryImage, secondaryImage])
            } else {
                handler(nil, "ERROR: Empty parsed image objects", nil)
            }
        }
    }
}

private extension SignatureComparison{
    
    class func computePercentage(numImg: ParsedImage, denImg: ParsedImage) -> Double{
        var totalPercentage = 0.0
        for numVector in numImg.vectors{
            if let denVector = denImg.vectors.min(by: {abs($0.angle - numVector.angle) < abs($1.angle - numVector.angle)}){
                var numerator = 0.0
                if denVector.angle >= numVector.angle{
                    numerator = 180 - (denVector.angle - numVector.angle)
                } else {
                    numerator = 180 - (numVector.angle - denVector.angle)
                }
                totalPercentage = totalPercentage + (numerator / 180)
            }
        }
        return totalPercentage / Double(denImg.vectors.count)
    }
}