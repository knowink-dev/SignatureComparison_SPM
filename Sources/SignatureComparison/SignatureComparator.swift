//
//  File.swift
//  
//
//  Created by Paul Mayer on 9/14/21.
//

import UIKit

/// Image comparison engine protocol
protocol SignatureComparatorProtocol {
    
    /// Compare two images, and produce a confidence score as to how close they are to each other.
    /// - Parameters:
    ///   - imageOne: The base UIImage to compare against
    ///   - imageTwo: The UIImage to compare to the first UIImage
    ///   - completion: The confidence score, or processing error, produced by comparing the two images. Result<Double>
    func compare(_ imageOne: UIImage,
                 to imageTwo: UIImage,
                 completion: @escaping (Swift.Result<Double, Error>) -> ())
}


open class SignatureComparator: SignatureComparatorProtocol {
    
    public init() {}
    
    open func compare(_ imageOne: UIImage, to imageTwo: UIImage, completion: @escaping (Swift.Result<Double, Error>) -> ()) {
        
        SignatureDriver.compare(imageOne, imageTwo) { result in
            completion(result)
        }
    }
}
