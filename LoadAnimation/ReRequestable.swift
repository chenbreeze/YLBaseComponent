//
//  ReRequestable.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/30.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import UIKit


public typealias ReRequestableView = ReRequestable & UIViewable

public protocol ReRequestable {
    typealias ReRequestFunctionType = () -> Void
    var request: ReRequestFunctionType { get set }
}

public protocol UIViewable{
    var view: UIView { get }
}


extension UIView: UIViewable{
    public var view: UIView {
        return self
    }
}
