//
//  InitialVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 17/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import SVProgressHUD

class InitialVC: UIViewController {
    
    fileprivate var categoryServices = CategoryService()
    fileprivate var categoryArray = Array<Category>()
    fileprivate var mobileArray = Array<Product>()
    fileprivate var tabletArray = Array<Product>()
    fileprivate static var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading")
        navigationController?.navigationBar.isHidden = true
        getCategories()
    }
    
}

///////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                     Custom Delegates                                     ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////

extension InitialVC: CategoryServiceDelegate {
    
    func didGetCategory(categoryArr: Array<Category>) {
        categoryArray = categoryArr
        getProducts()
        //configureCategory()
    }
    
    func didGetProducts(products: Array<Product>) {
        
        mobileArray = products.filter{$0.name == ParamKey.mobile}
        
        print(mobileArray.count)
    }
    
    func didGetProductWithCategory(products: Array<Product>, category: String) {
        
        if category == ParamKey.Mobiles {
            InitialVC.count = InitialVC.count + 1
            mobileArray = products
            navigateViewController()
        }
        if category == ParamKey.Tablets {
            InitialVC.count = InitialVC.count + 1
            tabletArray = products
            navigateViewController()
        }
    }
}

extension InitialVC: ErrorDelegate {
    
    func didErrorOccure(errorString: String?) {
        guard let error = errorString else {
            return
        }
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        SVProgressHUD.showError(withStatus: error)
    }
}


///////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                     Network Request                                      ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////

extension InitialVC {
    
    func getProducts() {
        for category in categoryArray {
            categoryServices.fetchProduct(productURL: category.productLink, product: category.name!)
        }
    }
    
    func getCategories() {
        categoryServices.fetchCategory()
        categoryServices.delegate = self
        categoryServices.errDelegate = self
    }
}


extension InitialVC {
    
    func navigateViewController() {
        
        let homeVc = storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        if InitialVC.count == 2 {
            homeVc?.mobileArray = self.mobileArray
            homeVc?.tabletArray = self.tabletArray
            homeVc?.categoryArray = self.categoryArray
            self.navigationController?.pushViewController(homeVc!, animated: true)
            SVProgressHUD.dismiss()
        }
    }
}
