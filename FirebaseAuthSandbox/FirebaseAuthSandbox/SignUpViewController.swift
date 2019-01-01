import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var authView: AuthViewController {
        return parent as! AuthViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailText.delegate = authView
        passwordText.delegate = authView
        firstNameText.delegate = authView
        lastNameText.delegate = authView
    }

    @IBAction func signUpPressed(_ sender: Any?) {
        authView.signUp(email: emailText.text, password: passwordText.text, name: "")
    }
}
