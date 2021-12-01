//
//  ItemDetailsViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 10/27/21.
//

import UIKit
import Firebase

class ItemDetailsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var scannedCode:String?
    var storeName:String?
    var itemName: String = ""
    var itemPrice: Double = 0

    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityLabel.text = String(1)
        view.backgroundColor = .white
        print(scannedCode!)
        if let scannedCode = scannedCode {
            //ItemDetailsLabel.text = scannedCode
            fetchItemDetails(scannedCode: scannedCode)
            print("item details", itemName, itemPrice)
//            itemNameLabel.text = result.0
//            priceLabel.text = String(result.1)
            
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reduceQty(_ sender: Any) {
        
        self.quantityLabel.text = String(Int(self.quantityLabel.text!)!-1)
        self.totalLabel.text = String(Double(self.quantityLabel.text!)!*Double(self.priceLabel.text!)!)
    }
    
    @IBAction func increaseQty(_ sender: Any) {
        self.quantityLabel.text = String(Int(self.quantityLabel.text!)!+1)
        self.totalLabel.text = String(Double(self.quantityLabel.text!)!*Double(self.priceLabel.text!)!)
    }
    func fetchItemDetails(scannedCode: String) {
        let docRef = db.collection("stores").document(storeName!).collection("items").document(scannedCode)
        
        docRef.getDocument{ (document, error) in
            if let document = document {
                let data = document.data()
                self.itemNameLabel.text = data?["itemName"] as? String ?? ""
                self.priceLabel.text = String(data?["itemPrice"] as? Double ?? 0)
                
                var qt: Double = Double(self.quantityLabel.text!)!
                var pr: Double = Double(self.priceLabel.text!)!
                self.totalLabel.text = String(qt*pr)
                self.priceLabel.text = self.priceLabel.text!
                
            } else {
                print("Error fetching user details")
            }
        }
//        print("item details", itemName, itemPrice)
//        return (itemName, itemPrice)
    }
    
    @IBAction func AddToCartButton(_ sender: Any) {
    }
    
    @IBAction func proceedToBuyButton(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cancelSegue" {
            let wecSeg = segue.destination as! HomeViewController
            wecSeg.usnm = storeName!
        }
    }
    @IBAction func cnacelButton(_ sender: Any) {
        performSegue(withIdentifier: "cancelSegue", sender: self)
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
