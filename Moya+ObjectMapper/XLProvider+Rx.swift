//
//  XLProvider+Rx.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Result

public typealias XLRequestResult<ModelType: Mappable> = (result:Result<ModelType, AnyError> , isCache:Bool)

public typealias XLRequestModel<ModelType: Mappable> = (model: ModelType, isCache: Bool)

extension XLProvider: ReactiveCompatible {}

public extension Reactive where Base: XLProviderType{
    
    /// Designated request-making method.
    public func requestModel<ModelType: Mappable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<XLRequestModel<ModelType>> {
        return Single.create { [weak base] single in
            
            
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result: Result<ModelType, AnyError>, isCache) in
                
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

    
    public func requestResult<ModelType: Mappable>(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<XLRequestResult<ModelType>> {
        return Observable.create { [weak base] observer in
            
            
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result: Result<ModelType, AnyError>, isCache) in
                
                switch result {
                case let .success(response):
                    let ele = Result<ModelType, AnyError>.init(value: response)
                    observer.onNext( (ele, isCache) )
                    
                case let .failure(error):
                    let ele = Result<ModelType, AnyError>.init(error: AnyError(error))
                    observer.onNext( (ele, isCache) )
                    
                }
                
            })
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
      
    }
    
}
