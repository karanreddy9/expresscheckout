//
//  HomePageViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 10/18/21.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    
    let stores = [ "Kroger", "Target", "Walmart", "Costco", "Aldi", "Fiesta", "Sprouts Market", "Whole Foods", "H-E-B", "Sam's Club", "Randalls"]
    var selectedStoreName: String?
    var selectedStoreImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        storeTableView.delegate = self
        storeTableView.dataSource = self
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! StoreTableViewCell

        // Configure the cell...
        let cellImage = cell.viewWithTag(1) as! UIImageView
        let cellLabel = cell.viewWithTag(2) as! UILabel
        
        cellImage.image = UIImage(named: self.stores[indexPath.row])
        cellLabel.text = self.stores[indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storeSelectedSegue" {
            let detailsView = segue.destination as! HomeViewController
            detailsView.usnm = selectedStoreName
            detailsView.storeImg = selectedStoreImage
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStoreName = stores[indexPath.row]
        selectedStoreImage = UIImage(named: stores[indexPath.row])
        self.performSegue(withIdentifier: "storeSelectedSegue", sender: self)
    }

}
