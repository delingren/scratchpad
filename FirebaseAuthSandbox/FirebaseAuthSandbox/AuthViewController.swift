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
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //signUpView.isHidden = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func logInSignUpChanged(_ sender: Any) {
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
    
    @IBAction func facebookSignIn(_ sender: Any) {
        //var action = UIAlertAction(title: "Facebook", style: .default) { (UIAlertAction) in
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            if let error = error {
                //self.showMessagePrompt(error.localizedDescription)
                print(error.localizedDescription)
            } else if result!.isCancelled {
                print("FBLogin cancelled")
            } else {
                // [START headless_facebook_auth]
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                // [END headless_facebook_auth]
                self.firebaseLogin(credential)
            }
        })
        //}
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        /*
         var action = UIAlertAction(title: "Google", style: .default) { (UIAlertAction) in
         // [START setup_gid_uidelegate]
         GIDSignIn.sharedInstance().uiDelegate = self
         GIDSignIn.sharedInstance().signIn()
         // [END setup_gid_uidelegate]
         }*/
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

