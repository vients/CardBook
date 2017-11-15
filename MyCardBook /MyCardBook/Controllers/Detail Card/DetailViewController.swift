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
//    @IBOutlet weak var frontImageDetail: UIImageView!
//    @IBOutlet weak var backImageDetail: UIImageView!
//    @IBOutlet weak var barcodeImageDetail: UIImageView!
    
//    var cardsDetail:Card?
//    var contentWidth:CGFloat = 0.0
    var imageCardsArray: [String]!
    
    private var manager = Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.pageControl.numberOfPages = imageCardsArray.count
//        for image in imageCardsArray.count {
//            let imageView:UIImageView = UIImageView()
//            imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) ))
////            imageForDetail.image = loadImageFromPath(date: imagelist[i])
//            imageView.contentMode = UIViewContentMode.scaleAspectFit
////            imageForDetail.frame = frame
//            imageView.frame = CGRect(x:0, y: 50, width: 100, height: 100)
//
//            scrollView.addSubview(imageView)
//        }
        loadImage()
       view.bringSubview(toFront: pageControl)
    }
    
    func loadImage()
    {
//        let images = imageCardsArray.count
//        if let cardsDetail = cardsDetail {
//            imageCardsArray = [cardsDetail.frontImage, cardsDetail.backImage,cardsDetail.barcode]
//            print("Image count ===\(imageCardsArray.count)")
//        }
        for (image, _) in imageCardsArray.enumerated() {
//        for image in images {
            var frame = CGRect.zero
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(image)
            frame.origin.y = 0
            frame.size = self.scrollView.frame.size
            
            let imageView:UIImageView = UIImageView()
            imageView.transform = imageView.transform.rotated(by: CGFloat((Double.pi / 2) ))
            imageView.image = manager.loadImageFromPath(imgName: imageCardsArray[image])
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.frame = frame
//            let xCoordinate = view.frame.midX + view.frame.width * CGFloat(image)
//            contentWidth += view.frame.width
//            scrollView.addSubview(imageView)
//            imageView.frame = CGRect(x: 0 , y:  0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//
            scrollView.addSubview(imageView)
        }
//            scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
         self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imageCardsArray.count), height: self.scrollView.frame.size.height)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
//
//    }
//    func loadImage(){
//        scrollView.delegate = self
//        if let cardsDetail = cardsDetail
//        {
//
//            frontImageDetail.image = manager.loadImageFromPath(imgName: cardsDetail.frontImage)
//            frontImageDetail?.frame = CGRect(x: 10, y: 10, width:100, height: 100)
//            frontImageDetail.transform = frontImageDetail.transform.rotated(by: CGFloat(Double.pi/2))
//
//            backImageDetail.image = manager.loadImageFromPath(imgName: cardsDetail.backImage)
//            backImageDetail.transform = backImageDetail.transform.rotated(by: CGFloat(Double.pi/2))
//
//            //            barcodeImageDetail.image = manager.loadImageFromPath(imgName: cardsDetail.barcode)
//            barcodeImageDetail.image = manager.generateBarCodeFromString(string: cardsDetail.barcode)
//            barcodeImageDetail.transform = barcodeImageDetail.transform.rotated(by: CGFloat(Double.pi/2))
//        }
//
//    }
    
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
    
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        AppUtility.lockOrientation(.portrait)
    //        // Or to rotate and lock
    //        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    //
    //    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //
    //        // Don't forget to reset when view is being removed
    //        AppUtility.lockOrientation(.all)
    //    }
}
    
    

