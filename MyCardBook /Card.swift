//
//  Card+CoreDataClass.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/31/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {
    @NSManaged public var backImage: String
    @NSManaged public var barcode: String
    @NSManaged public var barcodeImage: String
    @NSManaged public var cardDescription: String?
    @NSManaged public var colorFilter: String
    @NSManaged public var date: Date
    @NSManaged public var frontImage: String
    @NSManaged public var name: String
}
