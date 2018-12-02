//
//  ProductDetailsVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 26/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import Kingfisher
import AXPhotoViewer

class ProductDetailsVC: UIViewController {

    var product: Product?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
        
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperTapp(_ sender: Any) {
        let quntity = Int(stepper.value)
        if let price = product?.price,
            let totalQauntity = product?.quantity {
                if totalQauntity >= quntity {
                    let finalPrice = price * stepper.value
                    priceLabel.text = String(finalPrice)
                    quantityLabel.text =  String(quntity)
                }
            }
    }
    @IBAction func addToCartTapp(_ sender: Any) {
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "cartInfo") as! CartVC
        
        navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func backButtonTapp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarItem.title = product?.brand
        setData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didMovieImageTapped))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        //setupNavigationBar()
    }
    
//    func setupNavigationBar() {
//        let navBar: UINavigationBar =  UINavigationBar()
//        self.view.addSubview(navBar)
//        navBar.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navBar.topAnchor.constraint(equalTo: view.topAnchor),
//            navBar.heightAnchor.constraint(equalToConstant: 90)
//            ])
//        if let brand = product?.brand {
//            let navItem = UINavigationItem(title: brand)
//            navBar.setItems([navItem], animated: false);
//        }
//        navBar.barTintColor = UIColor.white
//    }
    
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
}

extension ProductDetailsVC {
    
    @objc func didMovieImageTapped() {
        
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

