//
//  ViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/27/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController {
    
    var cards: [Card] = []
    
    @IBOutlet weak var nameCard: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
        cardTableView.reloadData()
    }
    
    func fetch() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            cards = try context.fetch(Card.fetchRequest()) as! [Card]
        } catch  {
            print("Fetching failed")
        }
    }
    
}

extension CardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! CardTableViewCell
        
        cell.nameCard.text = cards[indexPath.row].name
        cell.cardDescription.text = cards[indexPath.row].cardDescription
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        if editingStyle == .delete{
//            let card = cards[indexPath.row]
//            context.delete(card)
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            do {
//                cards = try context.fetch(Card.fetchRequest()) as! [Card]
//            } catch  {
//                print("Fetching failed")
//            }
//        }
//
//
//        cardTableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { action, index in
            print("edit button tapped")
        }
        editAction.backgroundColor = UIColor.lightGray
        
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { action, index in
            print("share button tapped")
        }
        shareAction.backgroundColor = UIColor.blue
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            print("delete button tapped")
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
//                    if editingStyle == .delete{
                        let card = self.cards[indexPath.row]
                        context.delete(card)
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        do {
                            self.cards = try context.fetch(Card.fetchRequest()) as! [Card]
                        } catch  {
                            print("Fetching failed")
                        }
//                    }
            
            
            self.cardTableView.reloadData()
                }
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, shareAction, editAction]
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) -> Void in
//            self.cards.remove(at: indexPath.row)
//
//            })
//
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action,indexPath) -> Void in
//            self.cards.remove(at: indexPath.row)
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//            let card = self.cards[indexPath.row]
//                context.delete(card)
//
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            do {
//                self.cards = try context.fetch(Card.fetchRequest()) as! [Card]
//                } catch  {
//                    print("Fetching failed")
//                        }
//            self.cardTableView.reloadData()
//        })
//
//        editAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
//        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
//
//        return [deleteAction]
//
//    }
    
}

