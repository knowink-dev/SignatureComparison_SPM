//
//  PixelStatus.swift
//  
//
//  Created by Paul Mayer on 9/13/21.
//

import Foundation

enum PixelStatus{
    case processed
    case normal
    case deleted
    case permanentlyDeleted
    case maybeDeleteBottomLeft
    case maybeDeleteBottomRight
    case restoredRight
    case maybeRestoreRight
    case restoredLeft
    case maybeRestoreLeft
}
