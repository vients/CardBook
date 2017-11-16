//
//  Constants.swift
//  MyCardBook
//
//  Created by Yurii Vients on 11/7/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import Foundation

struct Constant {
    struct cellIdentifier {
        static let cardListCell = "Cell"
    }
    struct segue {
        static let editCardSegue = "editCardSegue"
        static let detailVCSegue = "detailViewSegue"
        static let popoverSegue = "popoverSegue"
    }
    struct identifier {
        static let cardListIdentifier = "unwindToCardList"
    }
}
enum sortOperation: Int {
    case sortFromAtoZ = 0
    case sortFromZtoA = 1
    case dateUp = 2
    case dateDown = 3
}

enum tagColor: Int {
    case yellow = 10
    case blue = 11
    case red = 12
    case brown = 13
    case white = 14
}
enum MIMEType: String {
    case jpg = "image/jpeg"
    case png = "image/png"
   
    init?(type: String) {
        switch type.lowercased() {
        case "jpg": self = .jpg
        case "png": self = .png
        
        default: return nil
        }
    }
    
}



