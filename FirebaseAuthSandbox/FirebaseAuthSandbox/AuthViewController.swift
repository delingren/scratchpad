//
//  AuthViewController.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/22/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class AuthViewController: UIViewController {
    @IBOutlet weak var logInSignUp: UISegmentedControl!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var logInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func changedLogInSignUp(_ sender: Any) {
        switch (logInSignUp.selectedSegmentIndex){
        case 0:
            logInView.isHidden = false;
            signUpView.isHidden = true;
        case 1:
            logInView.isHidden = true;
            signUpView.isHidden = false;
        default:
            return
        }
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        if let email = emailText.text, let password = passwordText.text {
            self.showSpinner ("Creating user ...") {
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if error != nil {
                        self.hideSpinner {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                    }
                    
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        self.hideSpinner {
                            if error == nil {
                                self.showMessagePrompt("Email verification sent. Check your email.") { action in
                                    self.dismiss(animated: true)
                                }
                            }
                            else {
                                self.showMessagePrompt(error!.localizedDescription)
                            }
                        }
                    }
                }
            }
        } else {
            showMessagePrompt("Email and password can't be empty")
        }
    }
    
    @IBAction func didTapEmailLogIn(_ sender: Any) {
        if let email = emailText.text, let password = passwordText.text {
            showSpinner ("Logging in ...") {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    self.hideSpinner {
                        if error != nil {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                        
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            showMessagePrompt("Email and password can't be empty")
        }
    }
    
    @IBAction func didTapRecoverPassword(_ sender: Any) {
        if let email = emailText.text {
            self.showSpinner ("Sending password recovery email ...") {
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                    self.hideSpinner {
                        if error != nil {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                        
                        self.showMessagePrompt("Password recovery email sent")                    }
                }
            }
        } else {
            showMessagePrompt("Enter your email to reset your password")
        }
    }
    
    @IBAction func didTapFacebookLogIn(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            if error != nil {
                self.showMessagePrompt(error!.localizedDescription)
            } else if result!.isCancelled {
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.thirdPartyLogin(credential)
            }
        })
    }
    
    @IBAction func didTapGoogleLogIn(_ sender: Any) {
        /*
         var action = UIAlertAction(title: "Google", style: .default) { (UIAlertAction) in
         // [START setup_gid_uidelegate]
         GIDSignIn.sharedInstance().uiDelegate = self
         GIDSignIn.sharedInstance().signIn()
         // [END setup_gid_uidelegate]
         }*/
    }
    
    func thirdPartyLogin(_ credential: AuthCredential) {
        showSpinner ("Retrieving user information ...") {
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                self.hideSpinner {
                    if error != nil {
                        self.showMessagePrompt(error!.localizedDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
