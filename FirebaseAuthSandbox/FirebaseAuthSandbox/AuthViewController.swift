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

class AuthViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var logInSignUp: UISegmentedControl!
    
    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var facebookLogInButton: UIButton!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordRepeatText: UITextField!
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
//        googleLogInButton.layer.borderWidth = 1
//        googleLogInButton.layer.borderColor = UIColor.gray.cgColor
//        
//        facebookLogInButton.layer.borderWidth = 1
//        facebookLogInButton.layer.borderColor = UIColor.gray.cgColor
        
//        logInSignUp.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 22),
//            NSAttributedString.Key.foregroundColor: UIColor.lightGray
//            ], for: .normal)
//        logInSignUp.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 22),
//            NSAttributedString.Key.foregroundColor: UIColor.orange
//            ], for: .selected)
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
        if passwordText.text != passwordRepeatText.text {
            showMessagePrompt("Passwords don't match")
            return
        }
        
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
                return
            }
            
            if result!.isCancelled {
                self.showMessagePrompt("Facebook Login cancelled.")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            self.thirdPartyLogin(credential)
        })
    }
    
    @IBAction func didTapGoogleLogIn(_ sender: Any) {
         GIDSignIn.sharedInstance().uiDelegate = self
         GIDSignIn.sharedInstance().signIn()
    }
    
    // Implementing GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            self.showMessagePrompt(error!.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        self.thirdPartyLogin(credential)
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
