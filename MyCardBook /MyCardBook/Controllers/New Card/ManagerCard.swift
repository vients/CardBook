//
//  ManagerCoreData.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/31/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RSBarcodes_Swift
import AVFoundation

class Manager {
    
    private var cards: [Card] = []
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func addCard() {
        saveCard()
    }
    
    func fetch() -> [Card] {
        let context = getContext()
        do {
            cards = try context.fetch(Card.fetchRequest()) as! [Card]
            return cards
        } catch  {
            print("Fetching failed")
            
            return cards
        }
    }
    
    func delete(card: Card) {
        
        let context = getContext()
        context.delete(card)
        // call save context method
        saveCard()
    }
    private func  saveCard() {
        let context = getContext()
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
   
    public func saveImagePath (_ photo: UIImage )  -> String {
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let imgName = UUID().uuidString + ".jpg"
        
        let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(imgName))// Change extension if you want to save as PNG
        
        let imageString = String(describing: imgPath)
        
        do{
            try UIImageJPEGRepresentation(photo, 1.0)?.write(to: imgPath, options: .atomic)
        }catch let error{
            print(error.localizedDescription)
        }
        print("image URL = \(imageString)")
        return imgName
    }
    
    
    public func loadImageFromPath(imgName: String) -> UIImage? {
        
        var imageData: Data?
        var image: UIImage?
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let imageURL = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent(imgName))
        
//        DispatchQueue.main.async {
        do {
             imageData = try Data(contentsOf: imageURL)
             image  = UIImage(data: imageData!)
            return image
           
        } catch {
            print(error.localizedDescription)
        }
//        }
    
        return nil
        
    }
   
//    public func generateBarCodeFromString(string: String) -> UIImage? {
//        let data = string.data(using: String.Encoding.ascii)
//
//        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
//            filter.setValue(data, forKey: "inputMessage")
//            if let output = filter.outputImage {
//                return UIImage(ciImage: output)
//            }
//        }
//
//        return nil
//
//
//    }
    
    public func generateBarCodeFromString(string: String) -> UIImage? {
        
        
        let imageBarCode = RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: AVMetadataObject.ObjectType.ean13.rawValue)
        return imageBarCode
    }
   
    
}

