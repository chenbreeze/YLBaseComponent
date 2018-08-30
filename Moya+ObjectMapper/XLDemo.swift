//
//  XLDemo.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import NSObject_Rx
import Result

enum XLTestApi {
    case home
    case user
}

extension XLTestApi: XLTargetType{
    
    var path: String {
        
        switch self {
        case .home:
            return "/home"
        case .user:
            return "/user"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .home:
            return ["id" : 23]
        case .user:
            return ["id" : 23]
        }
    }
    
}


class XLTest {
    let provider = XLProvider<XLTestApi>()
    
    func requestUser(){
        // 1
        provider.rx.requestModel(.home).subscribe(onSuccess: { (model:XLTestModel, isCache:Bool) in
        
            
        }) { (error) in
            
            }.disposed(by: disposeBag)
        
        // 2
        let userSequence = provider.rx.requestResult(.user) as Observable<XLRequestResult<XLTestModel>>
        
        // 3
        provider.rx.requestResult(.user).subscribe(onNext: { (result:Result<XLTestModel, AnyError> , isCache:Bool) in
            
    
            switch result {
            case .success(let model):
                break
                
            case .failure(let error):
                let err = error.error
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}

extension XLTest: HasDisposeBag {}

struct XLTestModel: Mappable {
    
    var name: String = ""
    var age: Int = 0
    var gender: Int = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
        gender <- map["sex"]
    }
    
}
