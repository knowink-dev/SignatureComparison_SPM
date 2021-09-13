//
//  File.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

extension Thread {
    class func printCurrent() {
        debugPrint("\nThread: \(Thread.current)\n" + "Operation Queue: \(OperationQueue.current?.name ?? "None")\n")
    }
}
