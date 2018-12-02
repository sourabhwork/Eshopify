//
//  ProductURL.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 24/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class ProductURL: Mappable {
    
    var link: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        link            <- map["href"]
    }
    
}

//struct SessionDictToArrayTransform: TransformType {
//
//    public typealias Object = Array<ProductURL>
//    public typealias JSON = Dictionary<String, Dictionary<String, Any>>
//
//    func transformFromJSON(_ value: Any?) -> Object? {
//        var itemArray = Array<ProductURL>()
//        if let dictObj = value as? Dictionary<String, Dictionary<String, Any>> {
//            for dict in dictObj.values {
//                if let item = Mapper<ProductURL>().map(JSONObject: dict) {
//                    itemArray.append(item)
//                }
//            }
//        } else if let dictObj = value as? Array<Dictionary<String, Any>> {
//            for dict in dictObj {
//                if let item = Mapper<ProductURL>().map(JSONObject: dict) {
//                    itemArray.append(item)
//                }
//            }
//        }
//
//        return itemArray
//    }
//
//    func transformToJSON(_ value: Object?) -> JSON? {
//        return nil
//    }
//}
