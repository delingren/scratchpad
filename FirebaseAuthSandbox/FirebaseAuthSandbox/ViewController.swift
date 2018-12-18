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
    let providers: [FUIAuthProvider] = [FUIGoogleAuth(),]
    
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
    
    @IBAction func loginAction(sender: AnyObject) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
    }
}

