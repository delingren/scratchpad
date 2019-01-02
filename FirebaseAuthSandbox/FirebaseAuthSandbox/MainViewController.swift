import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userVerified: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
        
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
    
    func loginAction(sender: AnyObject) {
        let authViewController = storyboard?.instantiateViewController(withIdentifier: "AuthViewController")
        self.present(authViewController!, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
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
            
            if let photoURL = user!.photoURL {
                DispatchQueue.global(qos: .default).async {
                    let data = try? Data(contentsOf: photoURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async(execute: {
                            self.userProfileImage?.image = image
                        })
                    }
                }
            } else {
                userProfileImage?.image = UIImage(named: "ic_user")
            }
        }
    }
}

