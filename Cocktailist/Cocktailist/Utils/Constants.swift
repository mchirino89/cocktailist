//
//  Constants.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 21/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import CoreGraphics.CGGeometry
import UIKit

struct Constants {
    
    struct UI {
        static let detailsSegue = "cocktailDetailSegue"
    }
    
    struct cell {
        static let name = "cocktailCell"
        static let height: CGFloat = 120
    }
    
    struct units {
        static let tableSections = 1
    }
}

struct Design {
    
    enum paddingCell: CGFloat {
        case top = 0
        case laterals = 16
        case bottom = 8
    }
    
    struct shadow {
        static let color = UIColor.black.cgColor
        static let radius: CGFloat = 2
        static let opacity: Float = 1/4
        static let offset = CGSize(width: 0, height: 1)
    }
    
}
