//
//  LoginViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/30/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var blurEffectView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        backgroundEffect()
    }
    
    func backgroundEffect()  {
        backgroundImageView.image = UIImage(named: "cloud")
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         blurEffectView?.frame = view.bounds
    }
    

}
