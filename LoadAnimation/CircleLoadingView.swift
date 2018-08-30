//
//  CircleLoadingView.swift
//  BaseComponent
//
//  Created by chenxiaofeng on 2018/1/19.
//  Copyright © 2018年 张强. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

public class CircleLoadingView : UIView{
    
    private let imageView = UIImageView().then{
        var images : [UIImage] = [UIImage]()
        for i in 1...9{
        let imageName = "circleLoading\(i)"
    
          images.append(UIImage(named: imageName)!)
        }
        $0.contentMode = .center
        $0.backgroundColor = UIColor.init(hex: 0x000000, alpha: 0.4)
        $0.animationImages = images
        $0.animationDuration = 0.5
        $0.animationRepeatCount = 0
        $0.layer.cornerRadius = 10.0
    }

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-70)
            make.width.equalTo(130.0)
            make.height.equalTo(110.0)
        }
    
    }
    
    override public func didMoveToSuperview() {
        if let _ =  superview{
            imageView.startAnimating()
        }else{
            imageView.stopAnimating()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
