//
//  Category.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 17/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Category: NSObject {
    
    var productLink: String?
    var id: Int?
    var name: String?
    var image: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
}



extension Category: Mappable {
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        productLink        <- map["products"]
    }
    
}
