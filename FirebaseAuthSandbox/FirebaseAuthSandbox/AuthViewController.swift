import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class AuthViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var logInSignUp: UISegmentedControl!
    
    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var facebookLogInButton: UIButton!
        
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var signUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
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
    
    @IBAction func facebookLogInPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            guard error == nil else {
                self.showMessagePrompt(error!.localizedDescription)
                return
            }
            guard !result!.isCancelled else {
                // User canceled, no need to show alert
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            self.thirdPartyLogin(credential)
        })
    }
    
    @IBAction func googleLogInPressed(_ sender: Any) {
         GIDSignIn.sharedInstance().uiDelegate = self
         GIDSignIn.sharedInstance().signIn()
    }
    
    // Implementing GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error == nil else {
            self.showMessagePrompt(error!.localizedDescription)
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        self.thirdPartyLogin(credential)
    }

    func thirdPartyLogin(_ credential: AuthCredential) {
        displaySpinner() {
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                self.removeSpinner() {
                    if error != nil {
                        self.showMessagePrompt(error!.localizedDescription)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func signUp(email: String?, password: String?, name: String?) {
        guard email != nil && password != nil && name != nil else {
            self.showMessagePrompt("Email, password, and name can't be empty")
            return
        }
        displaySpinner {
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                guard error == nil else {
                    self.removeSpinner {
                        self.showMessagePrompt(error!.localizedDescription)
                    }
                    return
                }
                Auth.auth().currentUser?.sendEmailVerification { error in
                    self.removeSpinner {
                        guard error == nil else {
                            self.showMessagePrompt(error!.localizedDescription)
                            return
                        }
                        self.showMessagePrompt("Verification sent. Check your email.") { _ in
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func emailLogIn(email: String?, password: String?) {
        guard email != nil && password != nil else {
            showMessagePrompt("Email and password can't be empty")
            return
        }
        displaySpinner {
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                self.removeSpinner {
                    guard error == nil else {
                        self.showMessagePrompt(error!.localizedDescription)
                        return
                    }
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func recoverPassword(email: String?) {
        guard email != nil else {
            showMessagePrompt("Enter your email to reset your password")
            return
        }
        displaySpinner {
            Auth.auth().sendPasswordReset(withEmail: email!) { error in
                self.removeSpinner {
                    guard error == nil else {
                        self.showMessagePrompt(error!.localizedDescription)
                        return
                    }
                    self.showMessagePrompt("Password recovery instructions sent, check your email")
                }
            }
        }
    }
}
