//
//  CheckOutViewController.swift
//  ExpressCheckout
//
//  Created by Karan Reddy P on 11/29/21.
//

import UIKit
import Firebase
import FirebaseAuth

class CheckOutViewController: UIViewController {
    
    struct ItemsInfo {
        let itemName: String
        var quantity: Int
        var price: Double
        let description: String
    }
    
    var itemsInfo: [ItemsInfo] = []

    var storeName: String?
    var storeImg: UIImage?
    var oId: String?
    var itemsCount: Int?
    var subT: Double?
    var orderTax: Double?
    var orderTotal: Double?
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var noOfItems: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storeImage.image = storeImg
        storeNameLabel.text = storeName
        
        orderId.text = oId
        noOfItems.text = String(itemsCount!)
        subTotal.text = String(subT!)
        tax.text = String(orderTax!)
        total.text = String(orderTotal!)
        
        print("Checkout Details")
        print("\(oId) \(itemsCount) \(subT) \(orderTax) \(orderTotal)")
    }
    
    @IBAction func paymentButton(_ sender: Any) {
        insertOrder()
    }
    
    
    func insertOrder() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        let datetime = formatter.string(from: now)
        
        db.collection("users").document(uid!).collection("orders").document(oId!).setData(["orderDate": datetime, "orderID": oId!, "orderStore": storeName!, "orderTotal": subT!]) { (err) in
            if err != nil{
                print(err!)
            } else {
                for i in self.itemsInfo {
                    db.collection("users").document(uid!).collection("orders").document(self.oId!).collection("orderItems").document().setData(["itemName": i.itemName, "itemPrice": i.price, "itemQty": i.quantity])
                }
                print("Order successfully inserted")
            }
        }
    }
    
}
