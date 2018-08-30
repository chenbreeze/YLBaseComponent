//
//  ServerCrachView.swift
//  BaseComponent
//
//  Created by chenxiaofeng on 2018/1/19.
//  Copyright © 2018年 张强. All rights reserved.
//

import Foundation
import UIKit
import Then

public typealias SCVRefreshClosure = () -> Void


/// 不要直接使用此类 配合ViewController + Load 使用
public class ServerCrashView : UIControl{
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "serverCrach")
    }
    
    let text = UILabel().then {
        $0.text = "服务器秀逗了，点击重试"
        $0.textAlignment = .center
        $0.font =  UIFont.helveticaNeue(14.0)
        $0.textColor = UIColor.init(hex: 0x666666)
    }
    

    @objc var refreshClosure : SCVRefreshClosure?
    
    init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.vcBgColor
        self.addSubview(imageView)
        self.addSubview(text)
        
        self.addTarget(self, action: #selector(tappedInView), for: .touchUpInside)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(AutoWidth(87.0) + StatusBarHeight + NavigationBarHeight)
        }
        
        text.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(47.0)
        }
    }
    
    @objc private func tappedInView() -> Void{
        if let closure = refreshClosure{
            closure()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
