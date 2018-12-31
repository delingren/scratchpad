import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func recoverPasswordPressed(_ sender: Any) {
        (parent as! AuthViewController).recoverPassword(email: emailText.text)
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        (parent as! AuthViewController).emailLogIn(email: emailText.text, password: passwordText.text)
    }
}
