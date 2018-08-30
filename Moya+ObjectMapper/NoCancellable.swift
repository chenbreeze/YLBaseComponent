//
//  NoCancellable.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import Moya

class NoCancellable: Cancellable {
    var isCancelled: Bool{
        return true
    }
    
    func cancel() {
       assertionFailure("不可取消")
    }
}
