//
//  ViewController.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/17/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {

    var auth: Auth?
    var authUI: FUIAuth?
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        ]
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        auth = Auth.auth()
        authUI = FUIAuth.defaultAuthUI()!
        authUI?.delegate = self
        authUI?.providers = providers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = auth!.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        auth!.removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try authUI!.signOut()
        } catch {
            print("Failed to sign out")
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else {
            print("Signed in: \(user!)")
            return
        }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
            
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
}

