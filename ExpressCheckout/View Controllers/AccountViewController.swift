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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mblnoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var mblnoTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstNameLabel.alpha = 0
        emailLabel.alpha = 0
        mblnoLabel.alpha = 0
        addressLabel.alpha = 0
        
        addressTitle.alpha = 0
        nameTitle.alpha = 0
        emailTitle.alpha = 0
        mblnoTitle.alpha = 0
        loadCurrUserData()
    }
    override func viewDidAppear(_ animated: Bool) {
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
                
                let phnno = data?["mblno"] as? String ?? ""
                let addfirst = data?["addressLine1"] as? String ?? ""
                let city = data?["city"] as? String ?? ""
                let state = data?["state"] as? String ?? ""
                let zipcode = data?["zipcode"] as? String ?? ""
                
                
                self.firstNameLabel.text = firstName + " " + lastName
                self.emailLabel.text = email
                self.mblnoLabel.text = phnno
                if(addfirst != "" && city != "" && state != "" && zipcode != "")
                {
                    self.addressLabel.text = addfirst + ", " + city + ", " + state + ", " + zipcode
                    self.addressLabel.alpha = 1
                    self.addressTitle.alpha = 1
                }
                else{
                    self.addressLabel.alpha = 0
                    self.addressTitle.alpha = 0
                }
                
                
                self.firstNameLabel.alpha = 1
                self.emailLabel.alpha = 1
                self.mblnoLabel.alpha = 1
                self.nameTitle.alpha = 1
                self.emailTitle.alpha = 1
                self.mblnoTitle.alpha = 1
                
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
