//
//  UIFont+Extensions.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/5.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import UIKit

public extension UIFont{
    
    /// HelveticaNeue 字体, app主要字体
    public static func helveticaNeue(_ pxSize: CGFloat) -> UIFont{
        return UIFont.init(name: "HelveticaNeue", size: CGFloat(UIFont.adaptiveFontSize(pxSize)))!
    }
    
    /// 系统字体
    public static func system(_ pxSize: CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: CGFloat(UIFont.adaptiveFontSize(pxSize)))
    }
    
    /// 系统加粗字体
    public static func boldSystem(_ pxSize: CGFloat) -> UIFont{
        return UIFont.boldSystemFont(ofSize: CGFloat(UIFont.adaptiveFontSize(pxSize)))
    }
    
}

public extension UIFont{
    /// 自适应字体的大小
    static public func adaptiveFontSize(_ pxSize: CGFloat) -> CGFloat{
        if(pxSize <= 0){
            return 10.0
        }else{
            return  pxSize * (72/96) * 1.2 * (ScreenWidth/320.0)
        }
    }
}

