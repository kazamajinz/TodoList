//
//  ManualsViewController.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/30.
//

import UIKit

var images = ["task2.png", "setting2.png"]

class ManualViewController: UIViewController {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        imgView.image = UIImage(named: images[0])
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        imgView.image = UIImage(named: images[pageControl.currentPage])
    }
    
}



