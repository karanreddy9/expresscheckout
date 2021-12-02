//
//  AccountUpdateViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 12/1/21.
//

import UIKit
import Firebase

class AccountUpdateViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var firstNameValue: UITextField!
    @IBOutlet weak var lastNameValue: UITextField!
    @IBOutlet weak var emailValue: UITextField!
    @IBOutlet weak var phonenoValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createAlert(title: String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func updateData(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).updateData([
            "firstName": firstNameValue.text,
            "lastName": lastNameValue.text,
            "mblno": phonenoValue.text,
            "email": emailValue.text
        ])
        
        createAlert(title: "Account Information Updated!", msg: "")
        firstNameValue.text!.removeAll()
        lastNameValue.text!.removeAll()
        emailValue.text!.removeAll()
        phonenoValue.text!.removeAll()
        //self.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: {})
        
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
