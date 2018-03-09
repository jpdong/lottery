//
//  SlideGalleryView.swift
//  Zhongwei
//
//  Created by eesee on 2018/3/8.
//  Copyright © 2018年 zhongwei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol SlideGalleryViewDelegate {
    func galleryDataSource() -> [String]
    func galleryScrollerViewSize() -> CGSize
}

extension UIImageView {
    
    func imageFromURL(_ url:String, placeholder:UIImage) {
        if (url != nil) {
            self.kf.setImage(with: URL(string:url))
        } else {
            self.image = placeholder
        }
    }
}

class SlideGalleryView:UIViewController,UIScrollViewDelegate {
    
    var delegate:SlideGalleryViewDelegate!
    let screenWidth = UIScreen.main.bounds.size.width
    var currentIndex:Int = 0
    var dataSource:[String]?
    var firstImageView,secondImageView,thirdImageView:UIImageView?
    var scrollerView:UIScrollView?
    var scrollerViewWidth:CGFloat?
    var scrollerViewHeight:CGFloat?
    var pageControl:UIPageControl?
    var placeholderImage:UIImage!
    var autoScrollerTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size:CGSize = self.delegate.galleryScrollerViewSize()
        scrollerViewWidth = size.width
        scrollerViewHeight = size.height
        dataSource = self.delegate.galleryDataSource()
        setupScrollerView()
        setupPlaceholder()
        setupImageViews()
        setupPageController()
        setupAutoScrollerTimer()
        self.view.backgroundColor = UIColor.black
    }
    
    func setupScrollerView() {
        scrollerView = UIScrollView(frame:CGRect(x:0, y:0, width:self.scrollerViewWidth!, height:self.scrollerViewHeight!))
        scrollerView?.backgroundColor = UIColor.red
        scrollerView?.contentSize = CGSize(width:self.scrollerViewWidth! * 3,height:self.scrollerViewHeight!)
        scrollerView?.contentOffset = CGPoint(x:self.scrollerViewWidth!,y:0)
        scrollerView?.isPagingEnabled = true
        scrollerView?.bounces = false
        self.view.addSubview(scrollerView!)
    }
    
    func setupPlaceholder() {
        let font = UIFont.systemFont(ofSize:17.0,weight:UIFont.Weight.medium)
        let size = CGSize(width:scrollerViewWidth!, height:scrollerViewHeight!)
        placeholderImage = UIImage()
    }
    
    func setupImageViews() {
        firstImageView = UIImageView(frame:CGRect(x:0,y:0, width:scrollerViewWidth!, height:scrollerViewHeight!))
        secondImageView = UIImageView(frame:CGRect(x:scrollerViewWidth!,y:0,width:scrollerViewWidth!, height:scrollerViewHeight!))
        thirdImageView = UIImageView(frame:CGRect(x:scrollerViewWidth! * 2, y:0, width:scrollerViewWidth!, height:scrollerViewHeight!))
        scrollerView?.showsHorizontalScrollIndicator = false
        if (dataSource?.count != 0) {
            resetImageViewSource()
        }
        scrollerView?.addSubview(firstImageView!)
        scrollerView?.addSubview(secondImageView!)
        scrollerView?.addSubview(thirdImageView!)
    }
    
    func setupPageController() {
        pageControl = UIPageControl(frame:CGRect(x:screenWidth / 2 - 60, y:scrollerViewHeight! - 20, width:120,height:20))
        pageControl?.numberOfPages = dataSource!.count
        pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(pageControl!)
    }
    
    func setupAutoScrollerTimer() {
        autoScrollerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(letItScroll), userInfo: nil, repeats: true)
    }
    
    @objc func letItScroll() {
        let offset = CGPoint(x:scrollerViewWidth! * 2,y:0)
        print("let go offset:\(offset)")
        scrollerView?.setContentOffset(offset, animated: true)
    }
    
    func resetImageViewSource() {
        if currentIndex == 0 {
            firstImageView!.imageFromURL(dataSource!.last!,placeholder:placeholderImage)
            secondImageView!.imageFromURL(dataSource!.first!,placeholder:placeholderImage)
            let thirdImageIndex = dataSource!.count > 1 ? 1 : 0
            thirdImageView!.imageFromURL(dataSource![thirdImageIndex], placeholder:placeholderImage)
        } else if self.currentIndex == (dataSource!.count - 1) {
            firstImageView!.imageFromURL(dataSource![currentIndex - 1], placeholder:placeholderImage)
            secondImageView!.imageFromURL(dataSource!.last!,placeholder:placeholderImage)
            thirdImageView!.imageFromURL(dataSource!.first!,placeholder:placeholderImage)
        }else {
            firstImageView!.imageFromURL(dataSource![currentIndex - 1], placeholder:placeholderImage)
            secondImageView!.imageFromURL(dataSource![currentIndex], placeholder:placeholderImage)
            thirdImageView!.imageFromURL(dataSource![currentIndex + 1], placeholder:placeholderImage)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        print("offset:\(offset)")
        if (dataSource!.count != 0) {
            if (offset >= scrollerViewWidth! * 2) {
                scrollView.contentOffset = CGPoint(x:scrollerViewWidth!,y:0)
                currentIndex = currentIndex + 1
                if currentIndex == dataSource!.count {
                    currentIndex = 0
                }
            }
            if (offset <= 0) {
                scrollView.contentOffset = CGPoint(x:scrollerViewWidth!,y:0)
                currentIndex = currentIndex - 1
                if (currentIndex == -1) {
                    currentIndex = dataSource!.count - 1
                }
            }
            resetImageViewSource()
            pageControl?.currentPage = currentIndex
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        autoScrollerTimer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupAutoScrollerTimer()
    }
    
    func reloadData() {
        currentIndex = 0
        dataSource = delegate.galleryDataSource()
        pageControl?.numberOfPages = dataSource!.count
        pageControl?.currentPage = 0
        resetImageViewSource()
    }
    
}
