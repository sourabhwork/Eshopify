//
//  AppHelper.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 15/09/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit


class AppHelper {
    
    class func setLoginStatus(status: Int?) {
        guard let state = status else {
            return
        }
        let isLogin = UserDefaults.standard
        isLogin.set(state, forKey: ParamKey.isLogin)
    }
    
    class func getLoginStatus() ->Int {
        let isLogin = UserDefaults.standard.integer(forKey: ParamKey.isLogin)
        return isLogin
    }
    
    class func isLogin() ->Bool {
        if getLoginStatus() == 1 {
            return true
        } else {
            return false
        }
    }
}
