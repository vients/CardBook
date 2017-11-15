//
//  DetailViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 11/3/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageCardsArray: [String]!
    
    private var manager = Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        scrollView.delegate = self
        self.pageControl.numberOfPages = imageCardsArray.count
        loadImage()
        view.bringSubview(toFront: pageControl)
    }
    
    func loadImage()
    {
        for (image, _) in imageCardsArray.enumerated() {
            
            var frame = CGRect.zero
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(image)
            frame.origin.y = 0
            frame.size = self.scrollView.frame.size
            
            let imageView:UIImageView = UIImageView()
            imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) ))
            imageView.image = manager.loadImageFromPath(imgName: imageCardsArray[image])
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.frame = frame
            
            scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imageCardsArray.count), height: self.scrollView.frame.size.height)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToCardList", sender: self)
    }
    
}



