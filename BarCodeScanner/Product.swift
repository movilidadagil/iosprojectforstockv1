//
//  Product.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 30.03.2022.
//

import Foundation
class Product {
    static var sharedInstance = Product(data: ["ProductName" : "ProductName"])
    
    var productBarcode:String!
    var productName:String!
    var productCount:Double!
    var productPrice:Double!
    
    init(data: [String : Any]){
        productName = data["ProductName"] as? String ?? ""
        productCount = Double(data["ProductCount"] as? String ?? "")
        productPrice = Double(data["ProductPrice"] as? String ?? "")
        productBarcode = data["ProductBarcode"] as? String ?? ""

        
    }

}
