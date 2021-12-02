//
//  SignUpViewController.swift
//  ExpressCheckout
//
//  Created by Pailla, Sri Karan Reddy on 10/10/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
                   self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)

        }
    
    func validateFields() -> String? {
        // Check whether all fields are empty
        if firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter all the fields!"
        }
        
        if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Passwords do not match!"
        }
        
        return nil
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let err = validateFields()
        if err != nil {
            self.showError(err!)
        } else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = (emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("User already exist")
                } else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["uid": result!.user.uid, "firstName": firstName, "lastName": lastName, "email": email, "addressLine1": "", "city": "", "state": "", "zipcode": "" ]) { (err) in
                        if err != nil{
                            self.showError("User cannot be created")
                        } else {
                            self.transitionToHome()
                        }
                    }
                }
            }
        }
    }
    
    func showError(_ err: String) {
        errorLabel.text = err
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabBarViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
