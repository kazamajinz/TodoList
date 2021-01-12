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
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ManualViewController.respondToSwipeGesture(_:)))
                swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                self.view.addGestureRecognizer(swipeLeft)
                
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ManualViewController.respondToSwipeGesture(_:)))
                swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            // 네 개의 이미지 뷰에 초기 이미지(검은색 화살표) 저장
            pageControl.currentPage = 0
            imgView.image = UIImage(named: images[0])
            
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면 해당 이미지 뷰를 빨간색 화살표 이미지로 변경
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left :
                    pageControl.currentPage = 1
                    imgView.image = UIImage(named: images[1])
                case UISwipeGestureRecognizer.Direction.right :
                    pageControl.currentPage = 0
                    imgView.image = UIImage(named: images[0])
                default:
                    break
            }
        }
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        imgView.image = UIImage(named: images[pageControl.currentPage])
        print("pc")
    }
    
  
    
}



