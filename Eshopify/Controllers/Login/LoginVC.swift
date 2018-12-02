//
//  LoginVC.swift
//  Eshopify
//
//  Created by Sourabh Kumbhar on 28/07/18.
//  Copyright © 2018 Sourabh Kumbhar. All rights reserved.
//

import UIKit
import Floaty
import FLAnimatedImage
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn
import SVProgressHUD


class LoginVC: UIViewController {

    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFLd: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupFloatingActionButton()
        
        //GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (signIn != nil) {
            GIDSignIn.sharedInstance().signOut()
        }
        Floaty.global.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Floaty.global.hide()
    }
}

    //////////////////////////////////////////////////////////////////////////////
    ///                                                                        ///
    ///                           Setup UI                                     ///
    ///                                                                        ///
    //////////////////////////////////////////////////////////////////////////////

extension LoginVC {
    
    func setupFloatingActionButton() {
        Floaty.global.button.buttonImage = UIImage(named: "icon-social")
        Floaty.global.button.buttonColor = UIColor.white
        let facebookItem = FloatyItem()
        
        Floaty.global.button.addItem("Facebook", icon: UIImage(named: "icon-facebook") , handler: {_ in
           self.facebookLogin()
        })
        facebookItem.icon = UIImage(named: "icon-facebook")
        facebookItem.size = 40
        facebookItem.title = "Facebook"
        //Floaty.global.button.addItem(item: facebookItem)
        Floaty.global.button.size = 50
        
        let gmailItem = FloatyItem()
        Floaty.global.button.addItem("Gmail", icon: UIImage(named: "icon-google"), handler: {_
            in
            self.gmailLogin()
        })
        
        let twitterItem = FloatyItem()
        Floaty.global.button.addItem("Twitter", icon: UIImage(named: "icon-twitter"), handler: {_ in
            //  self.twitterLogin()
        })
        
        //Floaty.global.button.animationSpeed = 0.50
        Floaty.global.button.openAnimationType = .fade
        //Floaty.global.button.rotationDegrees = 90.00
        Floaty.global.show()
    }
    
    func facebookLogin() {
        let fbloginManager = FBSDKLoginManager()
        fbloginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) -> Void in
            //  if (error == nil){
            let fbloginresult : FBSDKLoginManagerLoginResult = result!
            // if user cancel the login
            if (result?.isCancelled)!{
                return
            }
        })
    }
    
    func gmailLogin() {
        print("Gmail Button tapp")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func twitterLogin() {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
    }
    
}

//////////////////////////////////////////////////////////////////////////////
///                                                                        ///
///                            Targets                                     ///
///                                                                        ///
//////////////////////////////////////////////////////////////////////////////

extension LoginVC {
    
    @IBAction func loginTapp(_ sender: Any) {
        
        let authenticationService = AuthenticationServices()
        authenticationService.delegate = self
        var parameter = Dictionary<String, Any>()
        
        if let email = userNameTxtFld.text {
            parameter[ParamKey.email] = email
        }
        if let password = passwordTxtFLd.text {
            parameter[ParamKey.password] = password
        }
        
        if (userNameTxtFld.text?.isEmpty)! && (passwordTxtFLd.text?.isEmpty)! {
            showAlertWithFailure(messege: "Please Enter all fields")
        }
        else if (passwordTxtFLd.text?.isEmpty)! {
            showAlertWithFailure(messege: "Please Enter Password")
        }
        else if (userNameTxtFld.text?.isEmpty)! {
            showAlertWithFailure(messege: "Please Enter Username")
        } else {
            authenticationService.loginRequest(params: parameter)
            SVProgressHUD.show(UIImage(named: "icon-waiting")!, status: "Wait....")
        }
    }
    
    
    @IBAction func leftBarButtonTapp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                      ///
///                           Gmail Delegate                                             ///
///                                                                                      ///
////////////////////////////////////////////////////////////////////////////////////////////

extension LoginVC: GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
       
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: GIDSignInDelegate  {
    
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

//////////////////////////////////////////////////////////////////////////////////////////
///                                                                                    ///
///                           Custom Delegate                                          ///
///                                                                                    ///
//////////////////////////////////////////////////////////////////////////////////////////

extension LoginVC: AuthenticationServicesDelagate {
    
    func didFailure(messege: String) {
        showAlertWithFailure(messege: messege)
    }
    
    func didSuccess() {
        SVProgressHUD.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
}
