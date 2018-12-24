//
//  AuthViewController.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/22/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var logInSignUp: UISegmentedControl!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        signUpView.isHidden = true
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
    
}
