//
//  NoNetworkView.swift
//  BaseComponent
//
//  Created by chenxiaofeng on 2018/1/19.
//  Copyright © 2018年 张强. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit


public class NoNetworkView : UIView, ReRequestable{
 
    public var request: () -> Void{
        set{
            tapEvent = newValue
        }
        
        get{
            return tapEvent!
        }
    }
    
    
    let imageView = UIImageView().then {        
        $0.image = UIImage(named: "noNetwork")
    }
    
    let text = UILabel().then {
        $0.text = "网络竟然崩溃了，刷新页面试试~"
        $0.textAlignment = .center
        $0.font = UIFont.helveticaNeue(14.0)
        $0.textColor = UIColor.init(hex: 0x666666)
    }
    
    let button = UIButton().then{
        $0.layer.cornerRadius = 1.0
        $0.layer.borderColor = UIColor.mainYellowColor.cgColor
        $0.layer.borderWidth = 1.0
        $0.setTitle("刷新", for: .normal)
        $0.setTitleColor(UIColor.mainYellowColor, for: .normal)
        $0.titleLabel?.font = UIFont.helveticaNeue(15.0)
        $0.addTarget(self, action: #selector(tappedInView), for: .touchUpInside)
    }
    
    
    var tapEvent : (() -> Void)?
    
    init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.vcBgColor
        self.addSubview(imageView)
        self.addSubview(text)
        self.addSubview(button)
        
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(AutoWidth(87.0) + StatusBarHeight + NavigationBarHeight)
        }
        
        text.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(47.0)
        }
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(100.0)
            make.centerX.equalTo(self)
            make.top.equalTo(text.snp.bottom).offset(19.0)
        }
    }
    
    @objc private func tappedInView() -> Void{
        if let closure = tapEvent{
            closure()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
