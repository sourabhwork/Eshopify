 //
//  AppDelegate.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 17/06/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD

protocol AppDelegateProtocol: class {
    func didDisplayProducts(category: Category)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    
    
    var window: UIWindow?
    var centerContainer: MMDrawerController?
    fileprivate var categoryTableVC: CategoryTableVC!
    weak var delegate: AppDelegateProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        setupProgressView()
        //initialise sign-in
        GIDSignIn.sharedInstance().clientID = "523202177910-gl0k1k8ko1c55c8tf4hc4imsb148o8bq.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        window = UIWindow()

        //let rootViewController = self.window?.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let centralViewController = mainStoryboard.instantiateViewController(withIdentifier: "initialVC") as! InitialVC
        //let centralViewController = mainStoryboard.instantiateViewController(withIdentifier: "homeVC") as! HomeVC
         categoryTableVC = mainStoryboard.instantiateViewController(withIdentifier: "categoryTableVC") as! CategoryTableVC
        categoryTableVC.delegate = self

        let leftSideNav =   UINavigationController(rootViewController: categoryTableVC)
        let centralNav = UINavigationController(rootViewController: centralViewController)

        centerContainer = MMDrawerController(center: centralNav, leftDrawerViewController: leftSideNav)
    
        centerContainer?.openDrawerGestureModeMask = .panningCenterView
        centerContainer?.closeDrawerGestureModeMask = .panningCenterView

        //centerContainer?.centerHiddenInteractionMode = .navigationBarOnly
        centerContainer?.showsShadow = true

        //centerContainer?.maximumLeftDrawerWidth = 180
        centerContainer?.maximumLeftDrawerWidth = UIScreen.main.bounds.width / 2

        window?.rootViewController = centerContainer
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Eshopify")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    func configureCategory(categoryArr: Array<Category>) {
        //categoryTableVC.categoryArray = categoryArr
        categoryTableVC.configureCategoryMenu(categoryArr: categoryArr)
    }
    
    func setupProgressView() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    func setupDrawerController() {
        
    }
}

extension AppDelegate : CatgoryTableVCDelegate {
    
    func didDisplayProducts(cateogry: Category) {
        delegate?.didDisplayProducts(category: cateogry)
    }    
    
}


extension AppDelegate {
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled ||
        GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}

extension AppDelegate: GIDSignInDelegate  {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    
    
}
