//
//  AddCardVC.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/30/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import CoreData

class AddCardVC: UIViewController {

    @IBOutlet weak var frontCard: UITextField!
    @IBOutlet weak var nameCard: UITextField!
    @IBOutlet weak var backCard: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let card = Card(context: context)
        
        card.name = nameCard.text!
        card.frontImage = frontCard.text!
        card.backImage = backCard.text!
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    
}
