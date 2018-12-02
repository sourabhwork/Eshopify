//
//  NetworkHelper.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 07/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation


class NetworkHelper {
    
    class func getImageURL() -> String {
        return "http://evening-tundra-86781.herokuapp.com/getImage/list?imageName="
    }
    
    class func getBaseURL() -> String {
        return "http://evening-tundra-86781.herokuapp.com"
    }
}
