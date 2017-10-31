//
//  CardTableViewCell.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/27/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameCard: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
