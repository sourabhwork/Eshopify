//
//  DetailsProductVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 15/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import Kingfisher
import MMDrawerController
import SVProgressHUD

class ProductsVC: UIViewController {

    fileprivate var productArray = Array<Product>()
    var category: Category?
    
     @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupNavigationBar()
        SVProgressHUD.show()
        view.isUserInteractionEnabled = false
        fetchProduct()
        navigationBar.title = category?.name
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.shouldStretchDrawer = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
  
    
    /////////////////////////////////////////////////////////////////////////////////////
    ///                                                                                 ///
    ///                           Setup UI                                              ///
    ///                                                                                 ///
    ///////////////////////////////////////////////////////////////////////////////////////
}

extension ProductsVC {
    
    func setupNavigationBar() {

    }
    
}

extension ProductsVC {
    
    func fetchProduct() {
        let categoryServices = CategoryService()
        categoryServices.delegate = self
        categoryServices.fetchProduct(productURL: category?.productLink, product: (category?.name)!)
    }

    @IBAction func backButtonTapp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
///                                                                                    ///
///                           Custom Delegate                                          ///
///                                                                                    ///
//////////////////////////////////////////////////////////////////////////////////////////

extension ProductsVC: CategoryServiceDelegate {
    
    func didGetProductWithCategory(products: Array<Product>, category: String) {
        if self.category?.name == category {
            productArray = products
            collectionView.reloadData()
            SVProgressHUD.dismiss()
            view.isUserInteractionEnabled = true
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                         ///
///                           collectionView Delegate / DataSource                          ///
///                                                                                         ///
//////////////////////////////////////////////////////////////////////////////////////////////


extension ProductsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
}

extension ProductsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
        cell.imageView.kf.indicatorType = .activity
        cell.nameLabel.text = productArray[indexPath.row].name
        if let imageUrl =  productArray[indexPath.row].imageName {
            let image = NetworkHelper.getImageURL() + imageUrl
            let url = URL(string: image)
            cell.imageView.kf.setImage(with: url)
        }
        if let price = productArray[indexPath.row].price {
            cell.priceLabel.text = String(price)
        }
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "productdetailsViewController") as! ProductDetailsViewController
        productDetailsVC.product = productArray[indexPath.row]
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
}

extension ProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

