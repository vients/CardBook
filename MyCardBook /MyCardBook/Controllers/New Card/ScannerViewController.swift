//
//  ScannerViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 12/20/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerBarcodeDelegate: class {
    func scannerBarcode(barcodeText: String)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: ScannerBarcodeDelegate?
    @IBOutlet weak var textInfoLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scanField: UILabel!
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanBarCodeUseCamera()
        view.bringSubview(toFront: textInfoLabel)
        view.bringSubview(toFront: scanField)
        view.addSubview(backButton)
        addButtonOnSuperView()
    }
    
    
    func scanBarCodeUseCamera()  {
        captureDevice = AVCaptureDevice.default(for: .video)
        
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                print("Error Device Input")
            }
        }
    }
    func addButtonOnSuperView(){
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.white.cgColor
        scanField.layer.cornerRadius = 5
        scanField.layer.borderWidth = 2
        scanField.layer.borderColor = UIColor.white.cgColor
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            print("No Input Detected")
            return
        }
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        
        let alert = UIAlertController(title: "Card barcode", message: stringCodeValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (nil) in
            self.delegate?.scannerBarcode(barcodeText: stringCodeValue)
            self.dismiss(animated: true, completion: nil)
            self.videoPreviewLayer?.removeFromSuperlayer()
            self.captureSession?.stopRunning()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
