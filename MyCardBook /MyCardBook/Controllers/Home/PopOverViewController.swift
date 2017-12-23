//
//  PopOverViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 11/5/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit

protocol SortCardListDelegate {
    func sortCard(_ sort: sortOperation)
    func filterColor(_ filter: tagColor)
}

class PopOverViewController: UIViewController {
  
    var delegate : SortCardListDelegate?

    func buttonPressed(_ tag: Int) {
        delegate?.sortCard(sortOperation(rawValue: tag)!)
    }
    @IBAction func sortCardName(_ sender: UIButton) {
        buttonPressed(sender.tag)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sortDate(_ sender: UIButton) {
        buttonPressed(sender.tag)
        dismiss(animated: true, completion: nil)
    }
    
    func buttonFilterColor(_ tag: Int) {
        delegate?.filterColor(tagColor(rawValue: tag)!)
    }
  
    @IBAction func colorButton(_ sender: UIButton) {
        buttonFilterColor(sender.tag)
        dismiss(animated: true, completion: nil)
    }
    
}



