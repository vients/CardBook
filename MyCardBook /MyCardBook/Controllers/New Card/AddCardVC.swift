//
//  AddCardVC.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/30/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift
import AVFoundation

class AddCardVC: UIViewController, ScannerBarcodeDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    @IBOutlet weak var nameCard: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var descriptionCard: UITextView!
    @IBOutlet weak var characterLabel: UILabel!
    
    @IBOutlet var colorFilterCollection: [BEMCheckBox]!
    @IBOutlet weak var descriptionLabelToTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var generateBarcode: UIButton!
    @IBOutlet weak var createBarcodeButton: UIButton!
    
    fileprivate var imagePicker: WDImagePicker!
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    private var manager = Manager()
    var card:Card?
    
    let buttonOnSubView = UIButton(type: UIButtonType.system)
    let codedLabel:UILabel = UILabel()
    private var imagePicked = 0
    private var activeField: UITextField?
    private var colorTag : Int? = 0
    public var logo = "cardPlus"
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                barcodeTextField.isHidden = true
                barcodeImageView.isHidden = true
                self.descriptionLabelToTopConstraint.constant = 15.0
                
            } else {
                barcodeTextField.isHidden = false
                barcodeImageView.isHidden = false
                self.descriptionLabelToTopConstraint.constant = 126.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLogoToNavigationBar(logo: logo)
        isExpanded = false
        generateBarcode.isHidden = true
        editCardFunc()
        borderOnImage()
        nameCard.delegate = self
        descriptionCard.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))

    }
  
    @IBAction func createBarCode(_ sender: Any) {
       self.performSegue(withIdentifier: "ScanSegue", sender: nil)
        isExpanded = true
    }
    
    func scannerBarcode(barcodeText: String) {
        barcodeTextField.text = barcodeText
        barcodeImageView.image = manager.generateBarCodeFromString(barcode: barcodeText)
    }
    
    @IBAction func buttonGenerateBarcode(_ sender: Any) {
        barcodeImageView.image = manager.generateBarCodeFromString(barcode: barcodeTextField.text!)
    }
    
    @IBAction func addColorFilter(_ sender: UIButton) {
//        colorTag = nil
        
        for button in colorFilterCollection {
            if button.tag == sender.tag && button.on == true {
                colorTag = sender.tag
                button.setOn(true, animated: true)
            } else {
                button.setOn(false, animated: false)
            }
        }
        
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        saveToCoreData()
    }
    
    @IBAction func addFrontImage(_ sender: UIButton) {
        chooseImage()
        imagePicked = sender.tag
    }
    
    @IBAction func addBackCardImage(_ sender: UIButton) {
        chooseImage()
        imagePicked = sender.tag
    }

    private func saveToCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if nameCard.text != "" && frontImageView.image != #imageLiteral(resourceName: "front")  {
            if card == nil {
            let storeDescription = NSEntityDescription.entity(forEntityName: "Card", in: context)
            card = Card(entity: storeDescription!, insertInto: context)
            }
            card?.name = nameCard.text!
            card?.frontImage = manager.saveImagePath((frontImageView?.image)!)
            card?.backImage = manager.saveImagePath((backImageView?.image)!)
            card?.barcode = barcodeTextField.text!
           
            if barcodeImageView.image == nil{
                card?.barcodeImage = ""
            } else {
                card?.barcodeImage = manager.saveImagePath(barcodeImageView.image!)
                
            }
            card?.cardDescription = descriptionCard.text
            card?.date = Date()
            card?.colorFilter =  String(colorTag!)
            
            manager.addCard()
//            self.navigationController?.popToRootViewController(animated: true)
            performSegue(withIdentifier: Constant.identifier.cardListIdentifier, sender: self)
           
            return
        } else {
            let alertAddVC = UIAlertController(title: "Oops!",
                                               message: "Please fill in all fields for create card!",
                                               preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertAddVC.addAction(okAction)
            self.present(alertAddVC, animated: true, completion: nil)
        }
    }
    
     func editCardFunc() {
        
        if let card = card {
            isExpanded = true
            generateBarcode.isHidden = false
            colorFilterCollection[0].setOn(false, animated: true)
            nameCard.text = card.name
            frontImageView.image = manager.loadImageFromPath(imgName: card.frontImage)
            backImageView.image = manager.loadImageFromPath(imgName: card.backImage)
            barcodeTextField.text = card.barcode
            barcodeImageView.image = manager.loadImageFromPath(imgName: card.barcodeImage)
            descriptionCard.text = card.cardDescription
            colorTag = Int(card.colorFilter)!
            
            let index = Int(card.colorFilter)!
            colorFilterCollection[index].setOn(true, animated: true)
        }
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                if card == nil {
//                    let storeDescription = NSEntityDescription.entity(forEntityName: "Card", in: context)
//                    card = Card(entity: storeDescription!, insertInto: context)
//                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifaer = segue.identifier
        if identifaer == "ScanSegue" {
            let scann = segue.destination as? ScannerViewController
            scann?.delegate = self
        }
    }

    private func borderOnImage(){
        self.frontImageView.layer.borderWidth = 3.0
        self.frontImageView.layer.borderColor = #colorLiteral(red: 0.3854118586, green: 0.4650006294, blue: 0.5648224354, alpha: 1)
        self.backImageView.layer.borderWidth = 3.0
        self.backImageView.layer.borderColor = #colorLiteral(red: 0.3854118586, green: 0.4650006294, blue: 0.5648224354, alpha: 1)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addLogoToNavigationBar(logo: String) {
        let logo = UIImage(named: logo)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    @IBAction func done(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
       
//        dismiss(animated: true, completion: nil)
        
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

}

//MARK: ImagePicker, WDImagePicker
extension AddCardVC : UIImagePickerControllerDelegate, WDImagePickerDelegate, UINavigationControllerDelegate {
    
    private func chooseImage() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.showCustomPicker(.camera)
                self.present(imagePickerController, animated: true, completion: nil)
            } else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.showCustomPicker(.photoLibrary)
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCustomPicker(_ type: UIImagePickerControllerSourceType){
        self.imagePicker = WDImagePicker()
        self.imagePicker.cropSize = CGSize(width: 280, height: 280)
        self.imagePicker.delegate = self
        print(type)
        
        self.imagePicker.resizableCropArea = true
        self.imagePicker.sourceType = type
        print(type)
        self.imagePicker.setSourceType(type)
        self.present(self.imagePicker.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
        if imagePicked == 1 {
            self.frontImageView.image = pickedImage
        } else if imagePicked == 2 {
            self.backImageView.image = pickedImage
        }
        
        self.hideImagePicker()
    }
    
    func hideImagePicker() {
        self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let images  = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if imagePicked == 1 {
            frontImageView.image = images
        } else if imagePicked == 2 {
            backImageView.image = images
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        picker.dismiss(animated: true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Scan barcode
//extension AddCardVC: AVCaptureMetadataOutputObjectsDelegate {
//
//    func scanBarCodeUseCamera()  {
//        captureDevice = AVCaptureDevice.default(for: .video)
//
//        if let captureDevice = captureDevice {
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//
//                captureSession = AVCaptureSession()
//                guard let captureSession = captureSession else { return }
//                captureSession.addInput(input)
//
//                let captureMetadataOutput = AVCaptureMetadataOutput()
//                captureSession.addOutput(captureMetadataOutput)
//
//                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
//                captureMetadataOutput.metadataObjectTypes = [.code128, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
//
//                captureSession.startRunning()
//
//                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                videoPreviewLayer?.videoGravity = .resizeAspectFill
//                videoPreviewLayer?.frame = view.layer.bounds
//                view.layer.addSublayer(videoPreviewLayer!)
//
//                addButtonOnSuperView()
//                addLabelOnSuperView()
//
//            } catch {
//                print("Error Device Input")
//            }
//        }
//    }
//     func addButtonOnSuperView(){
//        buttonOnSubView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
//        buttonOnSubView.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 60)
//        buttonOnSubView.backgroundColor = .clear
//        buttonOnSubView.tintColor = .white
//        buttonOnSubView.layer.cornerRadius = 5
//        buttonOnSubView.layer.borderWidth = 2
//        buttonOnSubView.layer.borderColor = UIColor.white.cgColor
//        buttonOnSubView.setTitle("ENTER MANUALLY", for: .normal)
//        buttonOnSubView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        self.view.addSubview(buttonOnSubView)
//    }
//    func addLabelOnSuperView() {
//
//        codedLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 200)
//        codedLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 150 )
//        codedLabel.text = "Scan your cards barcode"
//        codedLabel.numberOfLines = 1
//        codedLabel.textColor = UIColor.white
//        codedLabel.font = UIFont.systemFont(ofSize: 19)
//        codedLabel.backgroundColor = UIColor.clear
//
//        self.view.addSubview(codedLabel)
//    }
//
//    @objc func buttonAction(sender: UIButton!) {
//        print("Button tapped")
//        generateBarcode.isHidden = false
//        createBarcodeButton.isHidden = true
//        buttonOnSubView.removeFromSuperview()
//        codedLabel.removeFromSuperview()
//        self.videoPreviewLayer?.removeFromSuperlayer()
//        self.captureSession?.stopRunning()
//
//    }
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if metadataObjects.count == 0 {
//            print("No Input Detected")
//            return
//        }
//        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//        guard let stringCodeValue = metadataObject.stringValue else { return }
//
//        let alert = UIAlertController(title: "Card barcode", message: stringCodeValue, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (nil) in
//            self.barcodeTextField.text = stringCodeValue
//            self.barcodeImageView.image = self.manager.generateBarCodeFromString(barcode: stringCodeValue)
//
//            self.codedLabel.removeFromSuperview()
//            self.buttonOnSubView.removeFromSuperview()
//            self.videoPreviewLayer?.removeFromSuperlayer()
//            self.captureSession?.stopRunning()
//
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//}

//MARK: UITextView
extension AddCardVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textContainer.maximumNumberOfLines = 5
        textView.textContainer.lineBreakMode = .byTruncatingTail
        let newText = (descriptionCard.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if(numberOfChars <= 140) {
            self.characterLabel.text = "\(140 - numberOfChars)"
            return true
        } else{
            return false
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint.init(x:0, y: textView.frame.origin.y - 190)
        self.scrollView.setContentOffset(scrollPoint, animated: true)

    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)

    }
}
//MARK: TextField
extension AddCardVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nameCard.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
}

// MARK: hidden keyboard when button tap
extension UIViewController {
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

//extension AddCardVC: ScannerBarcodeDelegate {
//    func scannerBarcode(barcodeText: String) {
//        barcodeTextField.text = barcodeText
//        print("NEW CHANGE \(barcodeText)")
//        barcodeImageView.image = manager.generateBarCodeFromString(barcode: barcodeText)
//    }
//}




