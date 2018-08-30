//
//  DataProvider.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import Result

/// A protocol representing a minimal interface for a MoyaProvider.
/// Used by the reactive provider extensions.
public protocol DataProviderType: AnyObject {
    
    associatedtype Target: YLTargetType
    
    typealias RequestResult = Result<Target.responseModelType , AnyError>
    typealias Completion = (_ result: RequestResult, _ isCache: Bool) -> Void
    
    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    func request(_ target: Target, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Completion) -> Cancellable
}

final class DataProvider<Target: YLTargetType>: DataProviderType{
    
    /// 修改这个变量添加默认plugin
    private var defaultPlugins: [PluginType] = [
        NetworkLoggerPlugin(verbose: false),
        JoinVeriSignaturePlugin(),
        AddTokenPlugin(),
        CheckErrorCodePlugin()
    ]
    
    private let moyaProvider: MoyaProvider<Target>
    
    // 这里最好替换成YYCache, 并做成单例的cache，这里只是做个样子
    private let cache = NSCache<NSString, NSData>()
    
    public init(plugins: [PluginType] = []) {
        
       moyaProvider =  MoyaProvider<Target>.init(
        plugins: defaultPlugins + plugins
        )
        
    }

    typealias RequestResult = Result<Target.responseModelType , AnyError>
    typealias Completion = (_ result: RequestResult, _ isCache: Bool) -> Void
  
    @discardableResult
    public func request(_ target: Target,
                      callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping Completion) -> Cancellable {
        
        if target.needCache {
            
            if target.cachePolicy != .reloadIgnoringLocalCacheData{
                if let cacheData = self.cache.object(forKey: NSString(string: target.cacheId())){
                    let fakeResponse = Response(statusCode: 0, data: cacheData as Data)
                    
                    self.handle(response: fakeResponse, isCache: true, completion: completion)
                    
                }else{
                    completion(RequestResult.init(error: AnyError(YLError.notFoundCacheError)), true)
                }
            }
        
            if target.cachePolicy == .retutnCacheDataDontLoad{
                return NoCancellable()
            }
            
        }
        
        return moyaProvider.request(target, callbackQueue: callbackQueue, progress: progress) { [weak self] (result) in
            
            guard let `self` = self else { return }
            
            switch result {
            case .success(let response):
                
                self.handle(response: response, isCache: false, completion: completion)
                
                self.handle(response: response, isCache: false, completion: { (result, iscache) in
                    
                    completion(result, iscache)
                    
                    switch result{
                    case .success(_):
                        //  只有成功的情况下 保存缓存数据
                        if target.needCache{
                            self.cache.setObject(NSData(data: response.data) , forKey: NSString(string: target.cacheId()))
                        }
                        
                    default:
                        break
                    }
                    
                })
            
            case .failure(let error):
                completion( RequestResult.init(error: AnyError(error)), false)
            }
            
        }
    }
    
    // 处理reponse
    private func handle(response: Response, isCache: Bool, completion: @escaping Completion){
        
        do {
            if let model = try response.mapCommonModel(type: Target.responseModelType.self){
                completion( RequestResult.init(value: model), isCache)
                
                
            }else{
                completion( RequestResult.init(error: AnyError(YLError.mapNilError)), isCache )
            }
            
        }catch{
            completion( RequestResult.init(error: AnyError(error) ), isCache)
        }
    }
}

