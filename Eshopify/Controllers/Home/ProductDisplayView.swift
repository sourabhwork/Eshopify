//
//  ProductDisplayView.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 07/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProductDisplayView: UIView {
    
    fileprivate var imageView = UIImageView()
    fileprivate var nameLabel = UILabel()
    fileprivate var priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(product: Product?) {
        
        imageView.image = nil
        if let image = product?.imageName {
            let imageUrl = NetworkHelper.getImageURL() + image
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url)
        }
        nameLabel.text = nil
        if let name = product?.name {
            nameLabel.text = name
        }
        priceLabel.text = nil
        if let price = product?.price {
            priceLabel.text = String(price)
        }
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                      ////
////                                Setup UI                                                              ////
////                                                                                                     ////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension ProductDisplayView {
    
    fileprivate func setupUI() {
        setupImageView()
        setupNameLabel()
        setupPriceLabel()
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 150)
            ])
        imageView.contentMode = .scaleAspectFit
        imageView.constraintsEqualToSuperView()
    }
    
    private func setupNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    private func setupPriceLabel() {
        self.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),            
            nameLabel.heightAnchor.constraint(equalToConstant: 25)
            ])
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: 12)
    }
}
