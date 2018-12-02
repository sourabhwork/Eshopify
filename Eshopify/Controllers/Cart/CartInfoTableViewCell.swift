//
//  CartInfoTableViewCell.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 07/09/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import Kingfisher

protocol CartTableViewCellDelegate: class {
    func removeTapp(tag: Int)
}

class CartInfoTableViewCell: UITableViewCell {

    weak var delegate: CartTableViewCellDelegate?
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var cellTag = 0
    
    @IBAction func removeButtonTapp(_ sender: Any) {        
        delegate?.removeTapp(tag: cellTag)
    }
    
    func setTag(tag: Int) {
        self.cellTag = tag
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //productImage.clipsToBounds = true
        //productImage.layer.cornerRadius = 65
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
