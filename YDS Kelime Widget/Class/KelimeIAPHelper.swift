//
//  KelimeIAPHelper.swift
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 2/4/15.
//  Copyright (c) 2015 Hayal Co. All rights reserved.
//

import UIKit

let kIdentifierFinger:String = "YDS_ALL_WORDS"

class KelimeIAPHelper: IAPHelper {
    
    class var shared : KelimeIAPHelper {
        
        struct Static {
            //     let productIdentifiers:NSSet = NSSet(objects:kIdentifierFinger)
            
            //          sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
            static let instance : KelimeIAPHelper = KelimeIAPHelper(productIdentifiers:NSSet(objects:kIdentifierFinger))
        }
        
        return Static.instance
    }
    
    
}
