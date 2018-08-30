//
//  Constants.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/4.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import UIKit

///  屏幕宽度
public let ScreenWidth : CGFloat = {
    return UIScreen.main.bounds.width
}()

/// 屏幕高度
public let ScreenHeight : CGFloat = {
    return UIScreen.main.bounds.height
}()

/// 当前机型是否是iPhoneX
public let IphoneX : Bool = {
    return __CGSizeEqualToSize(CGSize.init(width: 375.0, height: 812.0), UIScreen.main.bounds.size)
}()

/// 屏幕顶部额外高度， iPhoneX 是24 其他为0
public let ScreenTopExtraOffset : CGFloat = {
    return IphoneX ? 24.0 : 0.0
}()

/// 屏幕第部额外高度， iPhoneX 是34 其他为0
public let ScreenBottomExtraOffset : CGFloat = {
    return IphoneX ? 34.0 : 0.0
}()


/// 导航栏高度
public let NavigationBarHeight : CGFloat = 44.0


/// 状态栏高度
public let StatusBarHeight : CGFloat = {
    return IphoneX ? 44.0 : 20.0
}()

/// tab bar 高度
public let TabBarHeight : CGFloat = {
    return IphoneX ? 83.0 : 49.0
}()






