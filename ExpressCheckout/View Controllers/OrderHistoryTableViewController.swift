//
//  OrderHistoryTableViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 11/22/21.
//

import UIKit
import Firebase

struct OrderInfo {
    init()
    {
        orderid = ""
        orderdate = ""
        orderstore = ""
        ordertotal = 0.00
    }
    init(orderid: String, orderdate: String, orderstore: String, ordertotal: Double)
    {
        self.orderid = orderid
        self.orderdate = orderdate
        self.orderstore = orderstore
        self.ordertotal = ordertotal
    }
    
    var orderid: String
    var orderdate: String
    var orderstore: String
    let ordertotal: Double
}

class OrderHistoryTableViewController: UITableViewController {
    var count = 1
    
    let db = Firestore.firestore()

//    struct OrderInfo {
//        var orderid: Int
//        var orderdate: String
//        var orderstore: String
//        var ordertotal: String
//    }
//
//    var info: [OrderInfo] = []
    
    
    
    var info: [OrderInfo] = []
    var selectedOrder = OrderInfo()
//    var info: [OrderInfo] = [OrderInfo(orderid: "Mentos", orderdate: "asd", orderstore: "Kroger", ordertotal: "gum"), OrderInfo(orderid: "Lays", orderdate: "asdsa", orderstore: "Kroger", ordertotal: "chips")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("fetching orders")
//        fetchOrders()
        print("orders fetched")
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders()
    }
    
    func fetchOrders() {
        let uid = Auth.auth().currentUser?.uid
        
        self.info = []
        
        db.collection("users").document(uid!).collection("orders").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    let oid = data["orderID"] as? String ?? ""
                    let odate = data["orderDate"] as? String ?? ""
                    let ototal = data["orderTotal"] as? Double ?? 0.00
                    let ostore = data["orderStore"] as? String ?? ""
                    
                   
                    
                    self.info.insert(OrderInfo(orderid: oid, orderdate: odate, orderstore: ostore, ordertotal: ototal), at: 0)
                }
                print("order info in fetchoorders\(self.info)")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
          
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderSegue" {
            let itemdetailsView = segue.destination as! OrderHistoryItemsViewController
            itemdetailsView.selectedOrder = selectedOrder
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrder = info[indexPath.row]
        self.performSegue(withIdentifier: "orderSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("info count \(info.count)")
        return info.count
      
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath)
        
        print("order info in table view\(info)")

        // Configure the cell...
        let cellImage = cell.viewWithTag(1) as! UIImageView
        let cellLabel = cell.viewWithTag(2) as! UILabel
        let cellDate = cell.viewWithTag(3) as! UILabel
        let cellPrice = cell.viewWithTag(4) as! UILabel
        
        cellImage.image = UIImage(named: self.info[indexPath.row].orderstore)
        cellLabel.text = self.info[indexPath.row].orderstore
        cellDate.text = self.info[indexPath.row].orderdate
        cellPrice.text = String(self.info[indexPath.row].ordertotal)
        
        return cell
    }
}
