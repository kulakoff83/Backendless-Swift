//
//  Product.swift
//  Backendless-Swift
//
//  Created by Dmitry Kulakov on 26.01.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

import Foundation


class Product: NSObject {
    
    var productName: String?
    var imageURL: String?
    var price: NSNumber?
    var objectId : String?
    var productDescription: String = ""
    var image: UIImage?
    
    override var description: String {
        get {
            return self.productDescription
        }
        set {
            self.productDescription = newValue
        }
    }
    
}
