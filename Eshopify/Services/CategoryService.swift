//
//  CategoryService.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 17/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit

@objc protocol CategoryServiceDelegate: class {
    @objc optional func didGetCategory(categoryArr: [Category])    
    @objc optional func didGetProductWithCategory(products: Array<Product>, category: String)
}

protocol ErrorDelegate: class {
    func didErrorOccure(errorString: String?)
}

private struct Constant {
    //static let categoryUrl = "http://evening-tundra-86781.herokuapp.com/api/categories"
    static let categoryUrl = NetworkHelper.getBaseURL() + "/api/categories"
}

class CategoryService {
    
    weak var delegate: CategoryServiceDelegate?
    weak var errDelegate: ErrorDelegate?
    
    func fetchCategory() {
        let request = Alamofire.request(Constant.categoryUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{
            response in
             print(response)
            switch response.result {
            case .success(_):
                if let dict = response.result.value  as? Dictionary<String, Any> {
                    if let embed = dict[ParamKey._embedded] as? Dictionary<String,Any> {
                        if let category = embed[ParamKey.categories] as? Array<Dictionary<String, Any>> {
                            let categoryArr = Mapper<Category>().mapArray(JSONArray: category)
                            //  let categoryArr = Mapper<Category>().mapArray(JSONObject: category)
                            var i = 0
                            for cat in category {
                                if let link = cat[ParamKey._links] as? Dictionary<String,Any> {
                                    if let productLink = link[ParamKey.products] as? Dictionary<String, Any>,
                                        let link = productLink[ParamKey.href] as? String
                                    {
                                        categoryArr[i].productLink = link
                                    }
                                }
                                i = i + 1
                            }
                            self.delegate?.didGetCategory!(categoryArr: categoryArr)
                        }
                    }
                }
            case .failure(_):
                self.errDelegate?.didErrorOccure(errorString: response.error?.localizedDescription)
                break
            }
        }
        print(request.debugDescription)
    }
    
    func fetchProduct(productURL: String?, product: String) {
        
        guard let productUrl = productURL else {
            return
        }
        
        let request = Alamofire.request(productUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON{
            response in
            // print(response)
            
            switch response.result {
            case .success(_):
                if let dict = response.result.value as? Dictionary<String, Any> {
                    if let embed = dict[ParamKey._embedded] as? Dictionary<String, Any> {
                        if let products = embed[ParamKey.products]  as? Array<Dictionary<String, Any>>{
                            let productArr = Mapper<Product>().mapArray(JSONObject: products)
                            guard let productsArr = productArr else {
                                return
                            }
                            self.delegate?.didGetProductWithCategory!(products: productsArr, category: product)
                        }
                    }
                }
                break
            case .failure(_):
                
                self.errDelegate?.didErrorOccure(errorString: response.error.debugDescription)
                break
            }
        }
        print(request.debugDescription)
    }
}




