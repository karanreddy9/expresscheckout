//
//  OrderHistoryItemsViewController.swift
//  ExpressCheckout
//
//  Created by Karan Reddy P on 12/1/21.
//

import UIKit
import Firebase

struct ItemInfo {
    init()
    {
        itemName = ""
        itemPrice = 0.00
        itemQty = 0
    }
    init(itemName: String, itemPrice: Double, itemQty: Int)
    {
        
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.itemQty = itemQty
    }
    
    var itemName: String
    var itemPrice: Double
    let itemQty: Int
}

class OrderHistoryItemsViewController: UIViewController {
    
    var selectedOrder = OrderInfo()
    let db = Firestore.firestore()
    
    var itemInfo: [ItemInfo] = []
    var subtotal = 0.0
    var totalval = 0.0
    var tax1 = 0.0
    
    let stores = [ "Kroger", "Target", "Walmart", "Costco", "Aldi", "Fiesta", "Sprouts Farmers Market", "Whole Foods", "H-E-B", "Sam's Club", "Randalls"]
    

    @IBOutlet weak var storelogo: UIImageView!
    @IBOutlet weak var orderHistoryItemstableview: UITableView!
    @IBOutlet weak var itemStoreName: UILabel!
    @IBOutlet weak var itemSubtotal: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storelogo.image = UIImage(named: selectedOrder.orderstore)
        //itemStoreName.text = selectedOrder.orderstore
        itemStoreName.text = "Order Completed"
        orderHistoryItemstableview.delegate = self
        orderHistoryItemstableview.dataSource = self
        print("fetching items")
        //print(self.selectedOrder.orderstore)
        //print(self.selectedOrder.orderid)
        fetchItems(oid: selectedOrder.orderid)
        print("items fetched")
        self.itemSubtotal.text = "$" + String(round(Double(selectedOrder.ordertotal))*100/100)
        self.tax1 = (selectedOrder.ordertotal*8.25)/100
        self.tax.text = "$" + (String(round(Double(self.tax1))*100/100))
        self.total.text = "$" + String(round(Double(selectedOrder.ordertotal + self.tax1))*100/100)
    }
    

    func fetchItems(oid: String){
        let uid = Auth.auth().currentUser?.uid
        //let oid = Int(selectedOrder.orderid)
        print("Jai balayya")
        print(oid)
        db.collection("users").document(uid!).collection("orders").document(oid).collection("orderItems").getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting items: \(err)")
            } else {
                for document in querySnapshot!.documents
                {
                    let itemdata = document.data()
                    
                    let itname = itemdata["itemName"] as? String ?? ""
                    let itprice = itemdata["itemPrice"] as? Double ?? 0.00
                    let itqty = itemdata["itemQty"] as? Int ?? 0
                    
                    self.itemInfo.insert(ItemInfo(itemName: itname, itemPrice: itprice, itemQty: itqty), at: 0)
                    
                }
                print("item info in fetchoitems\(self.itemInfo)")
                
                DispatchQueue.main.async {
                    self.orderHistoryItemstableview.reloadData()
                }
                
            }
        }
        
    }

}
extension OrderHistoryItemsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemcell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryItemsCell", for: indexPath) as! OrderHistoryItemTableViewCell
        
        let itemCellImage = itemcell.viewWithTag(10) as! UIImageView
        let itemNameCellLabel = itemcell.viewWithTag(11) as! UILabel
        let qtyCellLabel = itemcell.viewWithTag(12) as! UILabel
        let priceCellLabel = itemcell.viewWithTag(13) as! UILabel
        
        itemCellImage.image = UIImage(named: self.itemInfo[indexPath.row].itemName)
        itemNameCellLabel.text = self.itemInfo[indexPath.row].itemName
        qtyCellLabel.text = "Qty:"+String(self.itemInfo[indexPath.row].itemQty)
        priceCellLabel.text = "$\(String(round(Double(self.itemInfo[indexPath.row].itemPrice * Double(self.itemInfo[indexPath.row].itemQty)))*100/100))"
        //self.subtotal = self.subtotal + (self.itemInfo[indexPath.row].itemPrice * Double(self.itemInfo[indexPath.row].itemQty))
        print("OrderHistorytblview")
        
        return itemcell
    }

}
