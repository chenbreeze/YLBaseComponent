//
//  SocketLoadingView.swift
//  BaseComponent
//
//  Created by chenxiaofeng on 2018/1/19.
//  Copyright © 2018年 张强. All rights reserved.
//

import Foundation
import UIKit
import Then

public class SocketLoadingView : UIImageView{
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.vcBgColor
        
        var images : [UIImage] = [UIImage]()
        for i in 1...15{
            let imageName = "socketLoading\(i)"
            images.append(UIImage(named: imageName)!)
        }
        contentMode = .center
        
        animationImages = images
        animationDuration = 1.5
        animationRepeatCount = 0
        
        startAnimating()
    }
    
    override public func didMoveToSuperview() {
        if let _ =  superview{
            startAnimating()
        }else{
            stopAnimating()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

