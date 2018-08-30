//
//  XLProvider.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/29.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import Result

/// A protocol representing a minimal interface for a MoyaProvider.
/// Used by the reactive provider extensions.
public protocol XLProviderType: AnyObject {
    
    associatedtype Target: XLTargetType
    
    /// Designated request-making method. Returns a `Cancellable` token to cancel the request later.
    func request<ModelType: Mappable>(_ target: Target, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping (_ result: Result<ModelType, AnyError>, _ isCache: Bool) -> Void ) -> Cancellable
}

final class XLProvider<Target: XLTargetType>: XLProviderType{
    
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
    
    // (_ result: Result<ModelType, AnyError>, _ isCache: Bool) -> Void
    
    //  Result<ModelType, AnyError>
    @discardableResult
    public func request<ModelType: Mappable>(_ target: Target,
                        callbackQueue: DispatchQueue? = .none,
                        progress: ProgressBlock? = .none,
                        completion: @escaping (_ result: Result<ModelType, AnyError>, _ isCache: Bool) -> Void) -> Cancellable {
        
        typealias RequestResult = Result<ModelType, AnyError>
        
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
                
                
                self.handle(response: response, isCache: false, completion: { (result: Result<ModelType, AnyError>, iscache: Bool) in
                    
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
    private func handle<ModelType: Mappable>(response: Response, isCache: Bool, completion: @escaping (_ result: Result<ModelType, AnyError>, _ isCache: Bool) -> Void) {
        
        do {
            
            let model = try response.mapCommonModel() as ModelType

            completion( Result<ModelType, AnyError>.init(value: model), isCache)

        }catch{
            completion( Result<ModelType, AnyError>.init(error: AnyError(error) ), isCache)
        }
    }
}
