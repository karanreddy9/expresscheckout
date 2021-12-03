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
    
    @IBOutlet weak var phonenoValue: UITextField!
    
    @IBOutlet weak var addressLine1Value: UITextField!
    @IBOutlet weak var cityValue: UITextField!
    @IBOutlet weak var stateValue: UITextField!
    @IBOutlet weak var zipcodeValue: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
                   self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func createAlert(title: String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)

        }
    
    @IBAction func updateData(_ sender: Any) {
        if(firstNameValue.text == "")
        {
            createAlert(title: "First Name is empty!", msg: "Enter Valid First Name")
            return
            
        }
        if(lastNameValue.text == ""){
            createAlert(title: "Last Name is empty!", msg: "Enter Valid Last Name")
            return
            
        }
        if(phonenoValue.text == ""){
            createAlert(title: "Phone number is empty!", msg: "Enter Valid Phone number")
            return
            
        }
        
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).updateData([
            "firstName": firstNameValue.text,
            "lastName": lastNameValue.text,
            "mblno": phonenoValue.text,
            "addressLine1": addressLine1Value.text,
            "city": cityValue.text,
            "state": stateValue.text,
            "zipcode": zipcodeValue.text
        ])
        
        createAlert(title: "Account Information Updated!", msg: "")
        firstNameValue.text!.removeAll()
        lastNameValue.text!.removeAll()
        phonenoValue.text!.removeAll()
        addressLine1Value.text!.removeAll()
        cityValue.text!.removeAll()
        stateValue.text!.removeAll()
        zipcodeValue.text!.removeAll()
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
