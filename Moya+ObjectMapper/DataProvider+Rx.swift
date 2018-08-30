//
//  DataProvider+Rx.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import RxSwift
import Result

extension DataProvider: ReactiveCompatible {}

public extension Reactive where Base: DataProviderType{
    
    typealias ModelType = (model: Base.Target.responseModelType, isCache: Bool)
 
    /// Designated request-making method.
    public func requestModel(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<ModelType> {
        return Single.create { [weak base] single in
            
            
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result, isCache) in
                
                switch result {
                case let .success(response):
                    single(.success((response, isCache)))
                case let .failure(error):
                    single(.error(YLError.wrappedCacheError(error: error, isCache: isCache) ))
                }
            
            })
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
    typealias RequestResult = (result: Result<Base.Target.responseModelType, AnyError>, isCache: Bool)
    
    public func requestResult(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<RequestResult> {
      
        return requestModel(token, callbackQueue: callbackQueue).asObservable().map({ (data) in
            
            let wrappedData = Result<Base.Target.responseModelType, AnyError>.init(value: data.model)
            
            return (wrappedData, data.isCache)
        }).catchError({ (error) in
          
            if let e = error as? YLError {
                switch e {
                case let .wrappedCacheError(error: error, isCache: isCache):
                    let wrappedData = Result<Base.Target.responseModelType, AnyError>.init(error: AnyError(error) )
                    return Observable.just( (wrappedData, isCache) )
                default:
                    break;
                }
            }
            
            let wrappedData = Result<Base.Target.responseModelType, AnyError>.init(error: AnyError(error) )
            return Observable.just( (wrappedData, false) )
        })
        
    }
   
}
