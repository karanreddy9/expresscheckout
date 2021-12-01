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
        
        // Stop capturing and hence stop executing metadataOutput function over and over again
        captureSession?.stopRunning()
        
        // Call the function which performs navigation and pass the code string value we just detected
        scannedCodenew = stringCodeValue
        fetchItemDetails(scannedCode: scannedCodenew!)
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
    }
}
