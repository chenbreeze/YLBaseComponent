//
//  RequestViewProtocol.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/31.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import UIKit

/// 请求数据 with 页面动画
public protocol PageRequestable: class{
    
    func requestData() 
    
    func pageLoadingView() -> UIView
    func layoutLoadingView(_ view: UIView)
    
    func requestFailedView(error: Error) -> ReRequestableView
    func layoutFailedView(_ view: ReRequestableView)
}

/// 请求数据 with hud动画, eg: 菊花样式
public protocol HudRequestable: class{
    func hudLoadingView() -> UIView
    func layoutHudLoadingView(_ view: UIView)
}
