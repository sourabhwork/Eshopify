//
//  CategoryTableVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 14/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit

protocol CatgoryTableVCDelegate: class {
    func didDisplayProducts(cateogry: Category)
}

class CategoryTableVC: UIViewController {

    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryArray = Array<Category>()
    weak var delegate: CatgoryTableVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.tableFooterView = UIView()        
    }

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                      ////
////                                Setup TableView                                                       ////
////                                                                                                     ////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CategoryTableVC {
    
    func configureCategoryMenu(categoryArr: Array<Category>) {
        categoryArray = categoryArr
        let category = Category()
        let isLogin = UserDefaults.standard.integer(forKey: "isLogin")
        print(isLogin)
        if isLogin == 0 {
            category.name = "LogIn"
            category.image = "icon-user"
        } else {
            category.name = "Logout"
            category.image = "icon-logout"
            let category1 = Category()
            category1.name = "Shopping Cart"
            category1.image = "icon-cart"
            categoryArray.append(category1)
        }
        categoryArray.append(category)
        setImagesToCategory()
        categoryTableView.reloadData()        
    }
    
    func setImagesToCategory() {
        for category in categoryArray {
            if category.name == ParamKey.Mobiles {
                category.image = "icon-mobile"
            }
            if category.name == ParamKey.Tablets {
                category.image = "icon-tablet"
            }
            if category.name == ParamKey.Desktops {
                category.image = "icon-desktop"
            }
            if category.name == ParamKey.Laptops {
                 category.image = "icon-laptop"
            }
            if category.name == ParamKey.Cameras {
                 category.image = "icon-camera"
            }
            if category.name == ParamKey.Televisions {
                 category.image = "icon-tv"
            }
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                      ////
////                                TableView Delegate / DataSource                                       ////
////                                                                                                     ////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CategoryTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        if let image = categoryArray[indexPath.row].image {
            cell.imageView?.image =  UIImage(named: image)
        }
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didDisplayProducts(cateogry: categoryArray[indexPath.row])        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension CategoryTableVC: UITableViewDelegate {
    
}


