//
//  StockViewModel.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 30.03.2022.
//

import UIKit
class StockViewModel {
    
    var imgProfile: UIImage? {
        didSet {
            imgProfileObserver?(imgProfile)
        }
    }

    var productName : String?{
        didSet
        {
            dataValidCheck()

        }
    }
    
    var productCount : String?{
        didSet
        {
            dataValidCheck()

        }
    }
    
    var productPrice : String?{
        didSet
        {
            dataValidCheck()

        }
    }



    
    fileprivate func dataValidCheck(){
        let  valid = productName?.isEmpty == false &&
        productCount?.isEmpty == false &&
        productPrice?.isEmpty == false

        stockDataValidObserver?(valid)

    }
    var stockDataValidObserver : ((Bool)->())?

    var imgProfileObserver : ((UIImage?) -> ())?
}
