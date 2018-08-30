//
//  MODemo.swift
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

enum YLTestApi {
   case home
   case user
}

extension YLTestApi: YLTargetType{
    
    typealias responseModelType = ResponseObjectModel<YLTestModel>
    
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

class YLTest {
    let provider = DataProvider<YLTestApi>()
    
    func requestUser(){
        provider.rx.requestModel(.home).subscribe(onSuccess: { (response) in
            
            let data = response.model
            let isCache = response.isCache
            
            if let model = data.data{
                
            }
            
            
        }) { (error) in
            
        }.disposed(by: disposeBag)
        
        
        provider.rx.requestResult(.user).subscribe(onNext: { (response) in
            
            let isCache = response.isCache
            let result = response.result
            
            switch result {
            case .success(let model):
                
                if let data = model.data {
                    //
                }
                
            case .failure(let error):
                let err = error.error
            }
            
        }).disposed(by: disposeBag)
        
    }
    
}

extension YLTest: HasDisposeBag {}

struct YLTestModel: Mappable {
    
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

