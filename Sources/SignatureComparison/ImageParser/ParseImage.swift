//
//  ParseImage.swift
//
//  Created by Paul Mayer on 5/12/21.
//

import UIKit
import CoreGraphics
import Accelerate

class ParseImage{
    
    /// Phase 1 Debug Image
    var imagePixelsPhase1: [[UInt32]]!
    
    #if DEBUG || FAKE_RELEASE
    /// Phase 2 Debug Image
    var imagePixelsPhase2: [[UInt32]]!
    
    /// Phase 3 Debug Image
    var imagePixelsPhase3: [[UInt32]]!
    
    /// Phase 4 Debug Image
    var imagePixelsPhase4: [[UInt32]]!
    #endif
    
    /// Active Pixels used in phases 2-4
    var imagePixelsArray: [ImagePixel] = []
    
    /// Dictionary used to create the neighboring pixels for each pixel.
    var pixelImageMap: [PixelCoordinate:ImagePixel] = [:]
    
    
    /// Parses an image pixel data of RGB and Monochrome. Image parser goes through 4 phases of destructing and constructing in order
    ///  to form lines / vectors with measurable angles to be used for comparison.
    /// - Parameters:
    ///   - inputImage: Image to parse
    /// - Returns: Image object that was parsed during execution.
    func parseImage(inputImage: UIImage) -> Result<ParsedImage>{
        
        //MARK: - Init Vars
        guard let cgImage = inputImage.cgImage,
              let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data)
        else {
            return .failure(.unableToParseImage("Couldn't access CG Image Data"))
        }
        imagePixelsPhase1 = [[UInt32]](
            repeating: [UInt32](
                repeating: UInt32.max,
                count: cgImage.width),
            count: cgImage.height)
        #if DEBUG || FAKE_RELEASE
        imagePixelsPhase2 = imagePixelsPhase1
        imagePixelsPhase3 = imagePixelsPhase2
        imagePixelsPhase4 = imagePixelsPhase1
        #endif
        
        let parsedImageObj = ParsedImage()

        //MARK: - Phase 1 - Converts image to black and white pixels only.
        #if DEBUG || FAKE_RELEASE
        var phaseOneStart: CFAbsoluteTime = 0
        var phase1Interval: Double = 0
        #endif
        
        if cgImage.colorSpace?.model == .rgb{
            #if DEBUG || FAKE_RELEASE
            phaseOneStart = CFAbsoluteTimeGetCurrent()
            #endif
            
            parseRgbImagePhase1(cgImage, bytes)
            #if DEBUG || FAKE_RELEASE
            phase1Interval = Double(CFAbsoluteTimeGetCurrent() - phaseOneStart)
            #endif
            
        } else if cgImage.colorSpace?.model == .monochrome{
            #if DEBUG || FAKE_RELEASE
            phaseOneStart = CFAbsoluteTimeGetCurrent()
            #endif
            
            parseMonochromeImagePhase1(cgImage, bytes)
            #if DEBUG || FAKE_RELEASE
            phase1Interval = Double(CFAbsoluteTimeGetCurrent() - phaseOneStart)
            #endif
        } else{
            return .failure(.invalidImageSupplied("Image is not in the correct format. Acceptable formats include RGBA and MonoChrome"))
        }
        
        //MARK: - Phase 2 - Delete all neighbor pixels to the left.
        #if DEBUG || FAKE_RELEASE
        imagePixelsPhase2 = imagePixelsPhase1
        let phaseTwoStart = CFAbsoluteTimeGetCurrent()
        #endif
        
        parseImagePhase2(cgImage)
        #if DEBUG || FAKE_RELEASE
        let phase2Interval = Double(CFAbsoluteTimeGetCurrent() - phaseTwoStart)
        #endif
        
        //MARK: - Phase 3 - Transform image signature into vectors.
        #if DEBUG || FAKE_RELEASE
        imagePixelsPhase3 = imagePixelsPhase2
        let phaseThreeStart = CFAbsoluteTimeGetCurrent()
        #endif
        
        parseImagePhase3()
        #if DEBUG || FAKE_RELEASE
        let phase3Interval = Double(CFAbsoluteTimeGetCurrent() - phaseThreeStart)
        #endif
        
        //MARK: - Phase 4 - Process all vectors and mapped them to their appropriate quadrants.
        #if DEBUG || FAKE_RELEASE
        let phaseFourStart = CFAbsoluteTimeGetCurrent()
        #endif
        
        parsedImageObj.vectors = parseImagePhase4(cgImage.height)
        #if DEBUG || FAKE_RELEASE
        let phase4Interval: Double = Double(CFAbsoluteTimeGetCurrent() - phaseFourStart)
        #endif
        
        //MARK: - Debug Info
        #if DEBUG || FAKE_RELEASE
        let debugInterval = CFAbsoluteTimeGetCurrent()
        let secondsPhase1 = (String(format: "%.4f", phase1Interval))
        let secondsPhase2 = (String(format: "%.4f", phase2Interval))
        let secondsPhase3 = (String(format: "%.4f", phase3Interval))
        let secondsPhase4 = (String(format: "%.4f", phase4Interval))
        let totalTime = (String(format: "%.4f", phase1Interval + phase2Interval + phase3Interval + phase4Interval))

        debugPrint("Phase1: \(secondsPhase1)")
        debugPrint("Phase2: \(secondsPhase2)")
        debugPrint("Phase3: \(secondsPhase3)")
        debugPrint("Phase4: \(secondsPhase4)")
        debugPrint("Parsing Time: \(totalTime)")

        parsedImageObj.debugImageDic[.phase1] = generateDebugImage(pixelArray: imagePixelsPhase1, cgImage: cgImage)
        parsedImageObj.debugImageDic[.phase2] = generateDebugImage(pixelArray: imagePixelsPhase2, cgImage: cgImage)
        parsedImageObj.debugImageDic[.phase3] = generateDebugImage(pixelArray: imagePixelsPhase3, cgImage: cgImage)
        parsedImageObj.debugImageDic[.phase4] = generateDebugImage(pixelArray: imagePixelsPhase4, cgImage: cgImage)
        let debugTime = Double(CFAbsoluteTimeGetCurrent() - debugInterval)
        debugPrint("Debug Time: \(debugTime)")
        debugPrint("")
        #endif
        
        return .success(parsedImageObj)
    }
}

//MARK: - Private Functions.
private extension ParseImage{
    
    /// Creates an actual UIimage from the 2D pixel data recieved. This is used to create the images for each phase in debug mode.
    /// - Parameters:
    ///   - pixelArray: 2D pixel array.
    ///   - cgImage: Current  core graphics image.
    /// - Returns: The Uimage of the 2D pixel array.
    func generateDebugImage(pixelArray: [[UInt32]], cgImage: CGImage) -> UIImage?{
        let imageData = pixelArray.flatMap({$0})
        let width = Int(cgImage.width)
        let height = Int(cgImage.height)
        let bitsPerComponent = 8
        let bytesPerPixel2 = 4
        let bytesPerRow = width * bytesPerPixel2
        let imageDataMemoryAllocation = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: imageDataMemoryAllocation,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo),
              let buffer = imageContext.data?.bindMemory(to: UInt32.self,
                                                         capacity: imageData.count)
        else { return nil}
        
        for index in 0 ..< width * height {
            buffer[index] = imageData[index]
        }
        return imageContext.makeImage().flatMap { UIImage(cgImage: $0) }
    }
}


