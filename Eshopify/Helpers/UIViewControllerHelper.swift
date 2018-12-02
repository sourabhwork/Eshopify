//
//  UIViewControllerHelper.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 26/08/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showAlert(title: String, messege: String, action: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        if action.count > 0 {
            for act in action {
                alert.addAction(act)
            }
        } else {
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithSuccess(msg: String?) {
        guard let messege = msg else {
            return
        }
        SVProgressHUD.showSuccess(withStatus: messege)
        SVProgressHUD.dismiss(withDelay: 1.3)
    }
    
    func showAlertWithFailure(messege: String?) {
        guard let msg = messege else {
            return
        }
        SVProgressHUD.showError(withStatus: msg)
        SVProgressHUD.dismiss(withDelay: 1.3)
    }    
}
