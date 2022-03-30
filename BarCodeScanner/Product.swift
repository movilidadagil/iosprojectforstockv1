//
//  Product.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 30.03.2022.
//

import Foundation
class Product {
    static var sharedInstance = Product()
    
    var productBarcode:String!
    var productName:String!
    var productCount:Double!
    var productPrice:Double!

}
