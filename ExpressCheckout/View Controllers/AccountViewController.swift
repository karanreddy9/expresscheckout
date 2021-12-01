//
//  AccountViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 10/18/21.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstNameLabel.alpha = 0
        lastNameLabel.alpha = 0
        emailLabel.alpha = 0
        loadCurrUserData()
    }
    
    func loadCurrUserData() {
        let uid = Auth.auth().currentUser?.uid
        
        let docRef = db.collection("users").document(uid!)

        docRef.getDocument { (document, error) in
         
            
            if let document = document {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                
                self.firstNameLabel.text = firstName
                self.lastNameLabel.text = lastName
                self.emailLabel.text = email
                
                self.firstNameLabel.alpha = 1
                self.lastNameLabel.alpha = 1
                self.emailLabel.alpha = 1
            } else {
                print("Error fetching user details")
            }
        }
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let signinViewController = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.signinViewController) as? SignInViewController)!
            view.window?.rootViewController = signinViewController
        } catch let error {
            print("Failed to sign out", error)
        }
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
