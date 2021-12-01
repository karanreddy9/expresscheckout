//
//  ScanViewController.swift
//  ExpressCheckout
//
//  Created by Naga Lakshmi Ratnala on 10/13/21.
//

import UIKit
import AVFoundation
import AudioToolbox
import Firebase

protocol InsertItemDetails {
    func addItem(itemName: String, quantity: Int, price: Double, desc: String)
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var itemDelegate: InsertItemDetails?
    
    let db = Firestore.firestore()
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    var scannedCodenew: String?
    var storeName: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view, typically from a nib.
//        navigationItem.title = "Scanner"
//        view.backgroundColor = .white
        
//        scannedCodenew = "8901030599170"
//
//        fetchItemDetails(scannedCode: scannedCodenew!)
        
//        print("dismissing scan")
//
//        dismissScreen()
//
//        print("scan dismissed")
        
        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
        
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                print("Error Device Input")
            }
            
        }
        
        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
//    func dismissScreen() {
//        let scanVC = ScanViewController()
//        scanVC.dismiss(animated: true, completion: {self.dismiss(animated: true, completion: nil)})
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        
        view.addSubview(codeFrame)
        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue
        
        // Play system sound with custom mp3 file
        if let customSoundUrl = Bundle.main.url(forResource: "beep-07", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
            
            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            
            AudioServicesPlaySystemSound(customSoundId)
        }
        
        // Stop capturing and hence stop executing metadataOutput function over and over again
        captureSession?.stopRunning()
        
        // Call the function which performs navigation and pass the code string value we just detected
        scannedCodenew = stringCodeValue
        
        
//        scannedCodenew = "8901030599170"
        
        fetchItemDetails(scannedCode: scannedCodenew!)
        
//        displayDetailsViewController(scannedCode: stringCodeValue)
        
    }
    
    func fetchItemDetails(scannedCode: String) {
        let docRef = db.collection("stores").document(storeName!).collection("items").document(scannedCode)
        
        docRef.getDocument{ (document, error) in
            if let document = document {
                let data = document.data()
                
                let itemName = data?["itemName"] as? String ?? ""
                let itemDesc = data?["itemDesc"] as? String ?? ""
                let itemQty = data?["itemQty"] as? Int ?? 1
                let itemPrice = data?["itemPrice"] as? Double ?? 0
                
                let homeVC = HomeViewController()
                homeVC.info.insert(HomeViewController.ItemInfo(itemName: itemName, quantity: itemQty, price: itemPrice, description: itemDesc), at: 0)
                
                self.itemDelegate?.addItem(itemName: itemName, quantity: itemQty, price: itemPrice, desc: itemDesc)
                
                
            } else {
                print("Error fetching user details")
            }
        }
//        print("item details", itemName, itemPrice)
//        return (itemName, itemPrice)
    }
    
    func displayDetailsViewController(scannedCode: String) {
        /*let detailsViewController = DetailsViewController()
        detailsViewController.scannedCode = scannedCode
        //navigationController?.pushViewController(detailsViewController, animated: true)
        present(detailsViewController, animated: true, completion: nil)*/
        
        
        let detailsViewController = ItemDetailsViewController()
        detailsViewController.scannedCode = scannedCode
        //self.dismiss(animated: true, completion: nil)
        //navigationController?.pushViewController(detailsViewController, animated: true)
        performSegue(withIdentifier: "scanToItemDetailsSegue", sender: self)
        /*
        
        present(detailsViewController, animated: true, completion: nil)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanToItemDetailsSegue" {
            let itemDetailsSeg = segue.destination as! ItemDetailsViewController
            itemDetailsSeg.scannedCode = self.scannedCodenew
            itemDetailsSeg.storeName = self.storeName
        }
    }

}
