//
//  HomeVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 12/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import iCarousel
import MMDrawerController
import Viewer
import AXPhotoViewer
import SVProgressHUD


class HomeVC: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var tabletCarouselView: iCarousel!
    @IBOutlet weak var mobileCarouselView: iCarousel!
    
    var mobileArray = Array<Product>()
    var tabletArray = Array<Product>()
    var categoryArray = Array<Category>()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        contentView.backgroundColor = UIColor.white
        scrollView.backgroundColor = UIColor.white
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        //setupiCarouselView()
        slidingImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.configureCategory(categoryArr: categoryArray)        
        setupiCarouselView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
}


//////////////////////////////////////////////////////////////////////////////
///                                                                        ///
///                           Setup UI                                     ///
///                                                                        ///
//////////////////////////////////////////////////////////////////////////////

extension HomeVC {

    func setupNavigationBar() {
        let navBar: UINavigationBar =  UINavigationBar()
        self.view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 70)
            ])
        let navItem = UINavigationItem(title: "Home")
        navBar.barTintColor = UIColor.white
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "icon-menu"), style: .plain, target: self, action: #selector(menuTapped))
        navItem.leftBarButtonItem = menuButton
        menuButton.tintColor = UIColor.black
        
        menuButton.imageInsets = UIEdgeInsetsMake(0, 0, 20, 20)        
        navBar.setItems([navItem], animated: false);
    }
    
    func setupiCarouselView() {
        mobileCarouselView.type = .cylinder
        tabletCarouselView.type = .linear
        // cylinder invetreed cylinder
        mobileCarouselView.bounces = true
        self.mobileCarouselView.autoscroll = 0.5
        self.tabletCarouselView.autoscroll = 0.4
        for i in 1...mobileArray.count {
            mobileCarouselView.scrollToItem(at: i, animated: true)
        }
        for i in (1...tabletArray.count) {
            tabletCarouselView.scrollToItem(at: i, animated: true)
            if i == tabletArray.count {
                tabletCarouselView.reloadData()
            }
        }
    }
    
    func slidingImages() {
        sliderImageView.animationImages = [
            UIImage(named: "slider1"),
            UIImage(named: "slider2"),
            UIImage(named: "slider3"),
            UIImage(named: "slider4"),
            ] as? [UIImage]
        
        sliderImageView.animationDuration = 7
        sliderImageView.startAnimating()
    }
}


///////////////////////////////////////////////////////////////////////////////////
///                                                                              ///
///                           iCarousel Delegate / DataSource                    ///
///                                                                              ///
////////////////////////////////////////////////////////////////////////////////////

extension HomeVC: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if carousel == mobileCarouselView  {
            return mobileArray.count
        } else {
            return tabletArray.count
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        if carousel == mobileCarouselView {
            let tempView = ProductDisplayView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
            tempView.configureView(product: mobileArray[index])
            
            return tempView
        } else {
            let tempView = ProductDisplayView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
            tempView.configureView(product: tabletArray[index])
            if index == 0 {
                tabletCarouselView.reloadData()
            }
            return tempView
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option ==  iCarouselOption.spacing {
            return value * 1.2
        }
        
        return value
    }
    
}

extension HomeVC: iCarouselDelegate {

    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == mobileCarouselView  {
            didMovieImageTapped(imageURL: mobileArray[index].getImage())
        } else {
        didMovieImageTapped(imageURL: tabletArray[index].getImage())
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////
///                                                                              ///
///                           AppDelegate Protocol                               ///
///                                                                              ///
////////////////////////////////////////////////////////////////////////////////////


extension HomeVC: AppDelegateProtocol {
    
    func didDisplayProducts(category: Category) {
        if category.name == "LogIn" {
        let loginVC  = storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.navigationController?.pushViewController(loginVC, animated: true)
            appDelegate.centerContainer?.closeDrawer(animated: true, completion: nil)
        } else if category.name == "Logout" {            
            SVProgressHUD.showSuccess(withStatus: "Logout Successfully")
            SVProgressHUD.dismiss(withDelay: 0.7)
            let logout = UserDefaults.standard.set(0, forKey: "isLogin")
            appDelegate.centerContainer?.closeDrawer(animated: true, completion: nil)
            appDelegate.configureCategory(categoryArr: categoryArray)
        } else if category.name == "Shopping Cart" {
            let cartVC = storyboard?.instantiateViewController(withIdentifier: "cartVC") as! CartVC
            self.navigationController?.pushViewController(cartVC, animated: true)
            appDelegate.centerContainer?.closeDrawer(animated: true, completion: nil)
        }  else {
            let detailProductVC  = storyboard?.instantiateViewController(withIdentifier: "productVC") as! ProductsVC
            detailProductVC.category = category
            self.navigationController?.pushViewController(detailProductVC, animated: true)
            appDelegate.centerContainer?.closeDrawer(animated: true, completion: nil)
        }        
    }
}


///////////////////////////////////////////////////////////////////////////////////////
///                                                                                 ///
///                            Targets                                              ///
///                                                                                  ///
////////////////////////////////////////////////////////////////////////////////////////

extension HomeVC {
    
    func didMovieImageTapped(imageURL: String?) {
        var photos = Array<AXPhoto>()
        
        if let image = imageURL {
            photos.append(AXPhoto(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: nil, url: URL(string: image))
            )
        }
        let data = AXPhotosDataSource(photos: photos, initialPhotoIndex: 0)
        let photosViewController = AXPhotosViewController(dataSource: data)
        self.present(photosViewController, animated: true, completion: nil)
    }    
    
    @objc func menuTapped() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        appDelegate.delegate = self
    }
    
    @IBAction func menuButtonTapp(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.configureCategory(categoryArr: categoryArray)
        appDelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
}
