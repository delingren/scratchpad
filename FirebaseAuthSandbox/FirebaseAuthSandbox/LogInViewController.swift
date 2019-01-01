import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var authView: AuthViewController {
        return parent as! AuthViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailText.delegate = authView
        passwordText.delegate = authView
    }
    
    @IBAction func recoverPasswordPressed(_ sender: Any) {
        authView.recoverPassword(email: emailText.text)
    }
    
    @IBAction func logInPressed(_ sender: Any?) {
        authView.emailLogIn(email: emailText.text, password: passwordText.text)
    }
}
