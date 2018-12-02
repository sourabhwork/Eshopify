//
//  ProductDetailsViewController.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 04/09/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import Kingfisher
import AXPhotoViewer
import LTNavigationBar
import SVProgressHUD
import CoreData

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var navigationItemTitle: UINavigationItem!
    
    var isUpdate: Bool = true
    
    @IBOutlet weak var cartBarButtonItem: UIBarButtonItem!
    
    var product: Product?
    let context = AppDelegate().persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.indicatorType = .activity
        navigationItemTitle.title = product?.brand
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        setData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didProductImageTapped))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        if AppHelper.isLogin() {
            cartBarButtonItem.isEnabled = true
        } else {
            cartBarButtonItem.isEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)        
        //self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
}
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    ///                                                                                 ///
    ///                           Setup UI                                              ///
    ///                                                                                 ///
    ///////////////////////////////////////////////////////////////////////////////////////
    
extension ProductDetailsViewController {
    
        func setData() {
            if let image = product?.getImage() {
                let url = URL(string: image)
                imageView.kf.setImage(with: url)
            }
            if let name = product?.name {
                nameLabel.text = name
            }
            if let description = product?.info {
                descriptionLabel.text = description
            }
            if let price = product?.price {
                priceLabel.text = String(price)
            }
            if let quantity = product?.price {
                priceLabel.text = String(quantity)
            }
        }
        
        func setupNavigationBar() {
            
            let navBar: UINavigationBar =  UINavigationBar()
            self.view.addSubview(navBar)
            navBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navBar.topAnchor.constraint(equalTo: view.topAnchor),
                navBar.heightAnchor.constraint(equalToConstant: 90)
                ])
            if let brand = product?.brand {
                let navItem = UINavigationItem(title: brand)
                navBar.setItems([navItem], animated: false);
            }
            //navBar.barTintColor = UIColor.white
        }
}

    //////////////////////////////////////////////////////////////////////////////
    ///                                                                        ///
    ///                            Targets                                     ///
    ///                                                                        ///
    //////////////////////////////////////////////////////////////////////////////

extension ProductDetailsViewController {
    
    @IBAction func stepperTapp(_ sender: Any) {
        let quntity = Int(stepper.value)
        if let price = product?.price,
            let totalQauntity = product?.quantity {
            if totalQauntity >= quntity {
                let finalPrice = price * stepper.value
                priceLabel.text =   "💸\(finalPrice)"        //String(finalPrice)
                quantityLabel.text =   "\(quntity)" //String(quntity)
                product?.totalPrice = Double(finalPrice)
                
            }
            isUpdate = true 
        }
    }
    @IBAction func addToCartTapp(_ sender: Any) {
        if isUpdate {
            if AppHelper.isLogin() {

            let productCart = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context) as! CartProduct
                showAlertWithSuccess(msg: "Product added Sucessfully")
                if let id = product?.id {
                    productCart.id = Int16(id)
                }
                if let name = product?.name {
                    productCart.name = name
                }
                if let quantity = quantityLabel.text {
                    productCart.quantity = Int16(quantity)!
                }
                if let image = product?.getImage() {
                    productCart.image = image
                }
                if let price = product?.price {
                    productCart.price = price
                }
                if let brand = product?.brand {
                    productCart.brand = brand
                }
                if let info = product?.info {
                    productCart.info = info
                }
                if let totalPrice = product?.totalPrice {
                    productCart.totalPrice = totalPrice
                }                
                do {
                    try context.save()
                    print("Insert Sucessfully")
                }
                catch {
                    print("Error in insert elements")
                }
                //showAlertWithFailure(messege: "Login First")
            } else {
                showAlertWithFailure(messege: "Login First")
            }
            isUpdate = false
        }
    }
    
    @IBAction func backButtonTapp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}

//////////////////////////////////////////////////////////////////////////////////////////
///                                                                                    ///
///                           Custom Delegate                                          ///
///                                                                                    ///
//////////////////////////////////////////////////////////////////////////////////////////

extension ProductDetailsViewController {
    
    @objc func didProductImageTapped() {
        
        var photos = Array<AXPhoto>()
        if let image = product?.getImage() {
            photos.append(AXPhoto(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: nil, url: URL(string: image))
            )
        }
        let data = AXPhotosDataSource(photos: photos, initialPhotoIndex: 0)
        let photosViewController = AXPhotosViewController(dataSource: data)
        self.present(photosViewController, animated: true, completion: nil)
    }
}
