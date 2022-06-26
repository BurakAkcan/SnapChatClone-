//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Burak AKCAN on 25.06.2022.
//

import UIKit
import ImageSlideshow

class SnapViewController: UIViewController {
    var selectedSnap:Snap?
    var inputArray = [KingfisherSource]()

    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        if let selectedSnap = selectedSnap {
            timeLabel.text = "Time left: \(selectedSnap.timeDifference)"
            for imageUrl in selectedSnap.imageUrlArray{
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 20, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.8))
            imageSlideShow.backgroundColor = UIColor.white
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel) // Stack gibi düşün bu hep önde görünecek
        }
        
        

    }
    

}
