//
//  ViewController.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/17/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userVerified: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let auth = Auth.auth()
        updateUserInfo(user: auth.currentUser)
        handle = auth.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        let authViewController = storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        self.present(authViewController!, animated: true)
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            userName.text = nil
            userEmail.text = nil
        } catch {
            print("Failed to sign out")
        }
    }
    
    func updateUserInfo(user: User?) {
        if (user != nil) {
            userName.text = user!.displayName
            userEmail.text = user!.email
            userVerified.text = user!.isEmailVerified ? "Verified" : "Not verified"
        }
    }
}

