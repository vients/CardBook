//
//  CardTableViewCell.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/27/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit

protocol CardCellSubclassDelegate: class {
    func buttonTapped(cell: CardTableViewCell)
}

class CardTableViewCell: UITableViewCell {

    var delegate: CardCellSubclassDelegate?
    
    @IBOutlet weak var descriptionToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageToBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var nameCard: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var colorTag: UIView!
    
    @IBOutlet weak var labelheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var backgroundCardView: UIView!
    
    
    var isExpanded:Bool = false {
        didSet {
            if isExpanded {
                descriptionToBottomConstraint.isActive = true
                imageToBottomConstraint.isActive = false
            } else {
                imageToBottomConstraint.isActive = true
                descriptionToBottomConstraint.isActive = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frontImage.layer.borderWidth = 3.0
        self.frontImage.layer.borderColor = UIColor.white.cgColor
        self.frontImage.layer.cornerRadius = 10.0
        self.detailButton.isHidden = false
        
        
        backgroundCardView.backgroundColor = UIColor.white
        contentView.backgroundColor = #colorLiteral(red: 0.3854118586, green: 0.4650006294, blue: 0.5648224354, alpha: 1)
//            UIColor(red: 200/255.0, green: 200/255.0, blue: 240/255.0, alpha: 1.0)
        backgroundCardView.layer.cornerRadius = 5.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.9).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }

    @IBAction func someButtonTapped(sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
    }
}
