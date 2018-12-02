//
//  Product.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 01/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Product: NSObject, Mappable {
    
    var id: Int?
    var name: String?
    var brand: String?
    var info: String?
    var price:  Double?
    var quantity: Int?
    var imageName: String?
    var totalPrice: Double? 
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        brand       <- map["brand"]
        info        <- map["description"]
        price       <- map["price"]
        quantity    <- map["quantity"]
        imageName   <- map["imageName"]
    }
    
    func getImage() -> String? {
        guard let image = imageName else {
            return nil 
        }
       // return "\(NetworkHelper.getImageURL) " + image
        let imageUrl = NetworkHelper.getImageURL()
        return imageUrl + image
        
    }
    
}


