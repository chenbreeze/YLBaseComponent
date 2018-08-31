//
//  RequestState.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/26.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import Foundation


public enum RequestState {
    case idle
    case loading
    case success(String?)
    case failure(Error, String?)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var isFailure: Bool {
        switch self {
        case .failure:
            return true
        default:
            return false
        }
    }
}

