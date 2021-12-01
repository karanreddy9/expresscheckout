//
//  HomeViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 10/12/21.
//

import UIKit

class HomeViewController: UIViewController, InsertItemDetails {
    
    struct ItemInfo {
        let itemName: String
        var quantity: Int
        var price: Double
        let description: String
    }
    
//    var info: [ItemInfo] = [ItemInfo(itemName: "Mentos", quantity: 1, price: 3.45, description: "gum"), ItemInfo(itemName: "Lays", quantity: 1, price: 4.25, description: "chips")]
    
    var info: [ItemInfo] = []
    
    var window: UIWindow?
    var usnm: String?
    var storeImg: UIImage?

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var us1 = usnm
        welcomeLabel.text = usnm!
        storeImage.image = storeImg
        // Do any additional setup after loading the view.
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }
    
    @IBAction func scanButton(_ sender: Any) {
        performSegue(withIdentifier: "scanButtonSegue", sender: self)
    }
    
    func addItem(itemName: String, quantity: Int, price: Double, desc: String) {
        itemTableView.beginUpdates()
        info.insert(ItemInfo(itemName: itemName, quantity: quantity, price: price, description: desc), at: 0)
        itemTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        itemTableView.endUpdates()
        print(info)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanButtonSegue" {
            let scanSeg = segue.destination as! ScanViewController
            scanSeg.storeName = self.usnm
            scanSeg.itemDelegate = self
        }
        
        if segue.identifier == "checkOutSeque" {
            let checkoutSeg = segue.destination as! CheckOutViewController
            checkoutSeg.storeImg = storeImage.image
            checkoutSeg.storeName = welcomeLabel.text
        }
    }
    
    @IBAction func stepperButton(_ sender: UIStepper) {
        let point = sender.convert(CGPoint.zero, to: itemTableView)
        guard let indexpath = itemTableView.indexPathForRow(at: point) else {return}
        
        let cell = itemTableView.cellForRow(at: indexpath)! as UITableViewCell
        
        info[indexpath.row].quantity = Int(Int(sender.value).description)!
        
        let cellItemQty = cell.viewWithTag(4) as! UILabel
        cellItemQty.text = String(info[indexpath.row].quantity)
        
        let pr = round((self.info[indexpath.row].price)*(Double(info[indexpath.row].quantity))*100) / 100.0
        let cellItemPrice = cell.viewWithTag(3) as! UILabel
        cellItemPrice.text = String(pr)
    }
    
    @IBAction func removeButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: itemTableView)
        guard let indexpath = itemTableView.indexPathForRow(at: point) else {return}
        info.remove(at: indexpath.row)
        itemTableView.beginUpdates()
        itemTableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        itemTableView.endUpdates()
    }
    
    @IBAction func checkOutButton(_ sender: Any) {
        if info.count <= 0 {
            let alert = UIAlertController(title: "Cart is Empty!", message: "Please scan to add items to your cart.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "checkOutSeque", sender: self)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell

        // Configure the cell...
        let cellItemName = cell.viewWithTag(1) as! UILabel
        cellItemName.text = self.info[indexPath.row].itemName
        
        let cellItemDesc = cell.viewWithTag(2) as! UILabel
        cellItemDesc.text = self.info[indexPath.row].description
        
        let cellItemPrice = cell.viewWithTag(3) as! UILabel
        cellItemPrice.text = String(self.info[indexPath.row].price)
        
        let cellItemQty = cell.viewWithTag(4) as! UILabel
        cellItemQty.text = String(self.info[indexPath.row].quantity)
        
//        let cellStepper = cell.viewWithTag(5) as! UIStepper
//        cellStepper.stepValue = 1

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            info.remove(at: indexPath.row)
            print(info.count)
            if(info.count == 0) {
                itemTableView.alpha = 0
            }
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
