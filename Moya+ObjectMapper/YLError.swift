//
//  YLError.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation

enum YLError {
    case responseError
    case mapNilError
    case notFoundCacheError
    case wrappedCacheError(error: Error, isCache: Bool)
}

extension YLError: Swift.Error { }
