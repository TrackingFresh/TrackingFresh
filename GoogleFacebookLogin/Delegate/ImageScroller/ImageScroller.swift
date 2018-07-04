//
//  ImageScroller.swift
//  ImageScroller
//
//  Created by Akshaykumar Maldhure on 8/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol ImageScrollerDelegate {
    func pageChanged(index : Int)
}

class ImageScroller: UIView {
    
    var scrollView : UIScrollView = UIScrollView()
    var delegate : ImageScrollerDelegate? = nil
    var isAutoScrollEnabled = true
    var scrollTimeInterval = 0.3
    
    func setupScrollerWithImages(images : NSArray, offer : String) {
        scrollView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 168)
        scrollView.backgroundColor = UIColor.green
//        scrollView.frame = scrollFrame
        scrollView.delegate = self
        var x : CGFloat = 0.0
        let y : CGFloat = 0.0
        var index : CGFloat = 0
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize(width: CGFloat(images.count) * self.frame.size.width, height: self.frame.height)
        
         for i in 0..<(images.count){
            if offer == "Offer" {
                let imageView = UIImageView(frame: CGRect(x: x, y: y, width: scrollView.frame.width, height: scrollView.frame.height))
                let strimageurl = images[i]
                imageView.sd_setImage(with: URL(string:(strimageurl as! String)), placeholderImage: UIImage(named: " "))
                self.scrollView.addSubview(imageView)
                index = index + 1
                x = self.scrollView.frame.width * index
            }else{
                let imageView = UIImageView(frame: CGRect(x: x, y: y, width: scrollView.frame.width, height: scrollView.frame.height))
                let dictuiimage = images[i] as! [String:Any]
                let url = dictuiimage["url"] as! String
                imageView.sd_setImage(with: URL(string:(url)), placeholderImage: UIImage(named: " "))
                self.scrollView.addSubview(imageView)
                index = index + 1
                x = self.scrollView.frame.width * index
            }
  
        }
        self.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.gray
        if isAutoScrollEnabled{
            Timer.scheduledTimer(timeInterval: scrollTimeInterval, target: self, selector: #selector(autoscroll), userInfo: nil, repeats: true)
        }
       
    }
    
    @objc func autoscroll() {
        if isAutoScrollEnabled{
        let contentWidth = self.scrollView.contentSize.width
        let x = self.scrollView.contentOffset.x + self.scrollView.frame.size.width
        if x < contentWidth{
            self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        }
    }

}

extension ImageScroller : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNum = (Int)(self.scrollView.contentOffset.x / self.scrollView
            .frame.size.width)
        if let delegate = self.delegate{
            delegate.pageChanged(index: pageNum)
        }
    }
}
