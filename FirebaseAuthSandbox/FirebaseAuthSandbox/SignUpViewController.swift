//
//  SignUpViewController.swift
//  FirebaseAuthSandbox
//
//  Created by Deling Ren on 12/27/18.
//  Copyright © 2018 Deling Ren. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didTapSignUp(_ sender: Any) {
        (parent as! AuthViewController).signUp(email: emailText.text, password: passwordText.text, name: "")
    }
}
