//
//  SignInViewController.swift
//  ExpressCheckout
//
//  Created by Pailla, Sri Karan Reddy on 10/10/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
                   self.view.addGestureRecognizer(tap)
        errorLabel.alpha = 0
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {

            self.view.endEditing(true)

        }
    
    @IBAction func signInButton(_ sender: Any) {
        let err = validateFields()
        if err != nil {
            self.showError(err!)
        } else {
            let email = (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Email or Password Incorrect!")
                } else {
                    print("user details", result!)
                    self.transitionToHome()
                }
            }
        }
    }
    
    func validateFields() -> String? {
        // Check whether all fields are empty
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all the fields"
        }
        
        return nil
    }
    
    func showError(_ err: String) {
        errorLabel.text = err
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
       let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabBarViewController
        
       // let vc = self.storyboard?.instantiateViewController as? StoresTableViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

