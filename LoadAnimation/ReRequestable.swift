//
//  ReRequestable.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/30.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import UIKit


public typealias ReRequestableView = ReRequestable & Viewable

public protocol ReRequestable: class {
    var request: () -> Void { set get }
}

public protocol Viewable{
    var realView: UIView { get }
}


