//
//  FavoriteCell.swift
//  BarCodeScanner
//
//  Created by Hasan Hüseyin Ali Gül on 31.03.2022.
//

import UIKit


class ProductCell: UITableViewCell {

    //outlets
    
    @IBOutlet weak var productLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFavCell(productData: Product)
    {
    
        self.productLabel.text = productData.productName!
        
        
    }
    
}
