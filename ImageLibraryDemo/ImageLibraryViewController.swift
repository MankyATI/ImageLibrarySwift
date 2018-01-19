//
//  ImageLibraryViewController.swift
//  ImageLibraryDemo
//
//  Created by Mayank on 1/14/18.
//  Copyright © 2018 Mayank. All rights reserved.
//

import UIKit
import SDWebImage

class ImageLibraryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate
{

    // MARK: - UI Controls
    var scrollViewZoom : UIScrollView!
    var scrollViewImagesPanel : UIScrollView!
    var btnClose : UIButton!
    
    
    // MARK: - properties
    
    var arrayImages : Array<Any>!
    var selectedIndex : Int = 0
    var bgColor : UIColor! // Default white
    var selectedColor : UIColor! // Defaul orange
    // set to false if you do not need the bottom image selector
    private let buttonOffset : Int = 100
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.setupView()
        self.addConstraints()
        self.makeMainScrollView()
        self.makeBottomScroll()
        self.focusSelectedIndex()
        self.view.bringSubview(toFront: btnClose)
    
        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scrollview Delegates
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        if scrollView == scrollViewZoom
        {
            return nil
        }
        if scrollView == scrollViewImagesPanel
        {
            return nil
        }
        for view in scrollView.subviews
        {
            if view.isKind(of: UIImageView.self)
            {
                return view
            }
        }
        return nil
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == scrollViewZoom
        {
            let width : CGFloat = UIScreen.main.bounds.size.width
//            var index : NSInteger = 0
            
            selectedIndex = NSInteger(scrollView.contentOffset.x)/NSInteger(width)
            let view = scrollViewImagesPanel.viewWithTag(buttonOffset * 2 + selectedIndex)
            view?.backgroundColor = bgColor
            self.selectImage()
        }
    }
    
    // MARK: - Button Selector
    
    @objc func tapSelectImage(_ button: UIButton) -> Void
    {
        selectedIndex = button.tag - buttonOffset
        self.focusSelectedIndex()
    }
    
    @objc func tapToZoom(_ gestureRecognizer: UITapGestureRecognizer) -> Void
    {
        let scrollView = gestureRecognizer.view as! UIScrollView
        if (scrollView.zoomScale > 1.0)
        {
            scrollView.setZoomScale(1, animated: true)
        }
        else
        {
            scrollView.setZoomScale(3, animated: true)
        }
    }
    
    @objc func panToClose(_ gestureRecognizer: UIPanGestureRecognizer) -> Void
    {
        
        let vel = gestureRecognizer.translation(in: self.view)
        if  vel.y > 0.0
        {
            self.view.transform = CGAffineTransform.init(translationX: vel.x, y: vel.y)
        }
        if(gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            if self.view.transform.ty > 120
            {
                self.dismiss(animated: true, completion: {
                    
                })
            }
            else
            {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform.identity
                    self.view.alpha = 1
                })
            }
            
        }
    }
    
    @objc func tapClose(_ button: UIButton) -> Void
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Gesture Delegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer is UIPanGestureRecognizer
        {
            let recon: UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = recon.velocity(in: self.view)
            let scrollView = gestureRecognizer.view as! UIScrollView
            
            if fabs(velocity.x) > 50 || scrollView.zoomScale > 1.0
            {
                return false
            }
        }
        return true
    }
    
    // MARK: - Private Methods
    
    private func setupView() -> Void
    {
        
        self.automaticallyAdjustsScrollViewInsets = false
        if bgColor == nil
        {
            bgColor = UIColor.white
        }
        if selectedColor == nil
        {
            selectedColor = UIColor.orange
        }
        self.view.backgroundColor = bgColor
        
        btnClose = UIButton()
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnClose)
        
//        btnClose.setImage(UIImage.init(named: "cross"), for: UIControlState.normal)
        btnClose.setTitle("close", for: UIControlState.normal)
        btnClose.addTarget(self, action: #selector(tapClose(_:)), for: UIControlEvents.touchUpInside)
        btnClose.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnClose]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnClose]))
    }
    
    private func addConstraints() -> Void
    {
        
        scrollViewZoom = UIScrollView()
        scrollViewZoom.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollViewZoom)
        
        scrollViewImagesPanel = UIScrollView()
        scrollViewImagesPanel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollViewImagesPanel)
        
        if showBottomBar == false
        {
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scrollViewZoom]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scrollViewZoom]))
            
        }
        else
        {
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scrollViewZoom]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0]-0-[v1(60)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scrollViewZoom,"v1":scrollViewImagesPanel]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scrollViewImagesPanel]))
        }

    }
    
    private func makeMainScrollView() -> Void
    {
        var xOrigin : CGFloat = 0
        let yOrigin : CGFloat = 0
        let width : CGFloat = UIScreen.main.bounds.size.width
        var height : CGFloat = (UIScreen.main.bounds.size.height - 124)
        if showBottomBar == false
        {
            height = height + 60.0
        }
        
        for i in 0...(arrayImages.count - 1)
        {
            let image = UIImage(named: "AddProductImage")
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.clipsToBounds = true

            
            let scrollViewInner = UIScrollView.init(frame: CGRect.init(x: xOrigin, y: yOrigin, width: width, height: height))
            scrollViewInner.addSubview(imageView)
            scrollViewInner.maximumZoomScale = 6.0
            scrollViewInner.minimumZoomScale = 1
            scrollViewInner.bouncesZoom = true
            scrollViewInner.delegate = self
            scrollViewInner.showsHorizontalScrollIndicator = false
            
            let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(tapToZoom(_:)))
            doubleTap.numberOfTapsRequired = 2
            scrollViewInner.addGestureRecognizer(doubleTap)
            scrollViewInner.canCancelContentTouches = false
            
            let panGest = UIPanGestureRecognizer.init(target: self, action: #selector(panToClose(_:)))
            panGest.delegate = self
            scrollViewInner.addGestureRecognizer(panGest)
            
            scrollViewZoom.addSubview(scrollViewInner)
            if arrayImages.count > 0
            {
                if arrayImages[i] is UIImage
                {
                    imageView.image = arrayImages[i] as? UIImage
                }
                else
                {
                    let imageUrl : String = arrayImages[i] as! String
                    imageView.sd_setImage(with: NSURL.init(string: imageUrl as String) as URL!)
                }
            }
            imageView.isUserInteractionEnabled = false
            imageView.frame = CGRect.init(x: 10, y: 10, width: width-20, height: height-20)
            xOrigin = xOrigin + width
        }
        let scrollContentWidth : CGFloat = width * (CGFloat(arrayImages.count))
        scrollViewZoom.contentSize = CGSize.init(width: scrollContentWidth, height: height)
        
        scrollViewZoom.isPagingEnabled = true
        scrollViewZoom.delegate = self
        scrollViewZoom.showsHorizontalScrollIndicator = false
        scrollViewZoom.canCancelContentTouches = false
    }
    
    private func makeBottomScroll() -> Void
    {
        var xOrigin : CGFloat = 0
        let yOrigin : CGFloat = 0
        let width : CGFloat = UIScreen.main.bounds.size.width/6
        let height : CGFloat = 60
        
        
        for i in 0...(arrayImages.count - 1)
        {
            // Create a container view to hold image
            let viewContainer = UIView.init(frame: CGRect.init(x: xOrigin, y: yOrigin, width: width, height: height))
            viewContainer.backgroundColor = bgColor
            viewContainer.tag = (buttonOffset*2 + i)
            scrollViewImagesPanel.addSubview(viewContainer)
            
            
            // Create the image view
            let image = UIImage(named: "AddProductImage")
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.backgroundColor = UIColor.black
            viewContainer.addSubview(imageView)
            if arrayImages.count > 0
            {
                if arrayImages[i] is UIImage
                {
                    imageView.image = arrayImages[i] as? UIImage
                }
                else
                {
                    let imageUrl : String = arrayImages[i] as! String
                    imageView.sd_setImage(with: NSURL.init(string: imageUrl as String) as URL!)
                }
            }
            imageView.frame = CGRect.init(x: 1, y: yOrigin + 1, width: width - 2, height: height - 2)
            
            
            // Create Button to select any particular Image
            let btnSelectImage = UIButton.init(type: UIButtonType.custom)
            btnSelectImage.addTarget(self, action: #selector(tapSelectImage(_:)), for: UIControlEvents.touchUpInside)
            btnSelectImage.tag = buttonOffset + i
            btnSelectImage.frame = CGRect.init(x: 1, y: yOrigin + 1, width: width - 2, height: height - 2)
            
            viewContainer.addSubview(btnSelectImage)
            xOrigin = xOrigin + width
        }
        let scrollContentWidth : CGFloat = width * (CGFloat(arrayImages.count))
        scrollViewImagesPanel.contentSize = CGSize.init(width: scrollContentWidth, height: height)
        scrollViewImagesPanel.isPagingEnabled = true
        
        scrollViewImagesPanel.canCancelContentTouches = false
        
        
        
    }
    
    private func focusSelectedIndex() -> Void
    {
        let width : CGFloat = UIScreen.main.bounds.size.width
        
        scrollViewZoom.contentOffset = CGPoint.init(x: CGFloat(selectedIndex) * CGFloat(width), y: 0)
        self.selectImage()
    }
    
    private func selectImage() -> Void
    {
        for i in 0...arrayImages.count
        {
            let view = scrollViewImagesPanel.viewWithTag(buttonOffset * 2 + i)
            view?.backgroundColor = bgColor
        }
        
        let view = scrollViewImagesPanel.viewWithTag(buttonOffset * 2 + selectedIndex)
        view?.backgroundColor = selectedColor
    }
}
