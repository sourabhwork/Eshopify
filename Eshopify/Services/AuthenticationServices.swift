//
//  AuthenticationServices.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 28/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthenticationServicesDelagate: class {
    func didSuccess()
    func didFailure(messege: String)
}

private struct Constant {
   // static let authenticationURL = "http://evening-tundra-86781.herokuapp.com/authenticate"
    static let authenticationURL = NetworkHelper.getBaseURL() + "/authenticate"
}

class AuthenticationServices {
    
    weak var delegate: AuthenticationServicesDelagate?
    
    func loginRequest(params: Dictionary<String, Any>) {
        
        let isLogin = UserDefaults.standard
        
        let request = Alamofire.request(Constant.authenticationURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result  {
            case .success(_):
                print(response.result.value!)
                if let dictResponse = response.result.value as? Dictionary<String, Any> {
                    if let suceessResponse = dictResponse[ParamKey.success] as? Int {
                        if suceessResponse == 0 {
                            print("Failure")
                            AppHelper.setLoginStatus(status: suceessResponse)
                            print(suceessResponse)
                            if let errorMessege = dictResponse[ParamKey.failure] as? String {
                                self.delegate?.didFailure(messege: errorMessege)
                            }
                        } else {
                            AppHelper.setLoginStatus(status: suceessResponse)
                            print(suceessResponse)
                            self.delegate?.didSuccess()
                        }                        
                    }
                }
                break
            case .failure(_):
                print("Failure")
                //self.delegate?.didFailure(messege: "The Internet connection appears to be offline")
                self.delegate?.didFailure(messege: response.error.debugDescription)
                AppHelper.setLoginStatus(status: 0)
                
            }
        }
        print(request.debugDescription)
    }
    
}
