//
//  CartVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 07/09/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class CartVC: UIViewController {
    
    @IBOutlet weak var cartTable: UITableView!
    @IBOutlet weak var subtotalButton: UIButton!
    
    fileprivate let placeOrederButton = UIButton()
    let context = AppDelegate().persistentContainer.viewContext
    let baseTag = 500
    var productsArray = Array<CartProduct>()
    var totalPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        subtotalButton.setBorder(1, color: UIColor.black)
        
        let request = NSFetchRequest<CartProduct>(entityName: "CartProduct")
        
        do {
            try productsArray = context.fetch(request)
        } catch {
            print("Unable to fetch")
        }
        setupSubtotalButton()
    }
    
}
    /////////////////////////////////////////////////////////////////////////////////////
    ///                                                                                 ///
    ///                           Setup UI                                              ///
    ///                                                                                 ///
    ///////////////////////////////////////////////////////////////////////////////////////

extension CartVC {

    func setupSubtotalButton() {
        totalPrice = 0.0
        for product in productsArray {
            totalPrice = totalPrice + product.totalPrice
        }
        //if productsArray.count == 0 {
        //    totalPrice = 0.0
        //}
        subtotalButton.setTitle("Cart Subtotal(\(productsArray.count) Items) : 💸 \(totalPrice)", for: .normal)
    }
    
    func setupTableView() {
        cartTable.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        cartTable.tableFooterView = UIView()
        cartTable.estimatedRowHeight = 70
        cartTable.rowHeight = UITableViewAutomaticDimension
    }
    
}


////////////////////// /////////////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                                                      ///
///                                         Targets                                                                    ////
///                                                                                                                      ///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CartVC {
    
    @IBAction func backButtonTapp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func placeOrderTapped(_ sender: Any) {
        showAlertWithSuccess(msg: "Placed Order Successfully")
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                                    ////
////                                TableView Delegate / DataSource                                                     ////
////                                                                                                                    ////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CartVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "cartInfo", for: indexPath) as! CartInfoTableViewCell
        cell.delegate = self
        cell.addShadowToView(cornerRadius: 10)
        let tag = baseTag + indexPath.row
        cell.tag = tag
        cell.setTag(tag: tag)
        let product = productsArray[indexPath.row]
        cell.productName.text = product.name
        cell.priceLabel.text = String(product.price)
        cell.quantityLabel.text = String(product.quantity)
        if let image = product.image {
            let url = URL(string: image)
            cell.productImage.kf.setImage(with: url)
        }
        cell.totalLabel.text = String(product.totalPrice)
        return cell 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let selectProduct = productsArray[indexPath.row]
        if editingStyle == .delete {
            context.delete(selectProduct)
            productsArray.remove(at: indexPath.row)
            cartTable.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            do {
                try context.save()
                showAlertWithSuccess(msg: "Item delete Successfully")
                setupSubtotalButton()
            } catch {
                print("Delete Unsuccessfull")
            }
        }
    }
    
}

extension CartVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                                                                                                    ////
////                                Custom Delegate                                                                     ////
////                                                                                                                    ////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CartVC: CartTableViewCellDelegate {
    
    func removeTapp(tag: Int) {
        let currentTag = tag - baseTag
        let currentProduct = productsArray[currentTag]
        let indexPath = IndexPath(row: currentTag, section: 0)
        context.delete(currentProduct)
        productsArray.remove(at: currentTag)
        cartTable.deleteRows(at: [indexPath], with: .automatic)
        cartTable.reloadData()
        do {
            try context.save()
            showAlertWithSuccess(msg: "Item delete Successfully")
            setupSubtotalButton()
        } catch {
            print("remove unsuccessfully ")
        }
    }        
}
