import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func signUpPressed(_ sender: Any) {
        (parent as! AuthViewController).signUp(email: emailText.text, password: passwordText.text, name: "")
    }
}
