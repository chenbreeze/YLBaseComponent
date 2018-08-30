//
//  HttpResponseModel+Rx.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/28.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper
import Result

public extension Response {
    
    /// 映射到一个自定义的数据类型
    func mapCommonModel<T: Mappable>() throws -> T{
        do {
            let jsonObj =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let object = Mapper<T>().map(JSONObject: jsonObj)
            
            if object == nil{
                throw YLError.mapNilError
            }
            
            return object!
            
        } catch YLError.mapNilError  {
            throw YLError.mapNilError
        }catch{
            throw YLError.responseError
        }
    }

    
    /// 映射到一个空数据类型
    func mapEmptyModel() throws -> ResponseEmptyModel?{
       return try mapCommonModel()
    }
    
    
    /// 映射到一个原始的数据类型
    func mapOriginalModel<T>(type:T.Type) throws -> ResponseOriginalModel<T>? {
        return try mapCommonModel()
    }
    
    /// 映射到一个遵循Mappable的数据对象
    func mapObjectModel<T : Mappable>(type:T.Type) throws -> ResponseObjectModel <T>? {
        return try mapCommonModel()
    }
    
    /// 映射到一个数组的数据类型
    func mapArrayModel<T : Mappable>(type:T.Type) throws -> ResponseArrayModel<T>? {
        return try mapCommonModel()
    }
    
}

public extension ObservableType where E == Response {
    
    /// 转换为一个自定义数据类型的Observable
    public func mapCommonModel<T: Mappable>() -> Observable<T?>{
        return flatMap { response -> Observable<T?> in
            return Observable.just(try response.mapCommonModel())
        }
    }
    
    /// 转换为一个空数据类型<包装>的Observable
    public func mapEmptyData() -> Observable<ResponseEmptyModel?>{
        return mapCommonModel()
    }
    
    /// 转换为一个原始类型<包装>的Observable
    public func mapOriginalData<T>() -> Observable<ResponseOriginalModel<T>?> {
        return mapCommonModel()
    }
    
    /// 转换为一个空数据类型<包装>的Observable
    public func mapObjectModel<T>() -> Observable<ResponseObjectModel<T>?> {
        return mapCommonModel()
    }
    
    /// 转换为一个遵循Mappable的数据对象类型<包装>的Observable
    public func mapArrayData<T>() -> Observable<ResponseArrayModel<T>?> {
        return mapCommonModel()
    }
}

public typealias ResponseCommonObjectResult<T> = Result<T?, AnyError>

public typealias ResponseEmptyModelResult = Result<ResponseEmptyModel?, AnyError>

public typealias ResponseOriginalModelResult<T> = Result<ResponseOriginalModel<T>?, AnyError>

public typealias ResponseObjectModelResult<T: Mappable> = Result<ResponseObjectModel<T>?, AnyError>

public typealias ResponseArrayModelResult<T: Mappable> = Result<ResponseArrayModel<T>?, AnyError>


public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response{

     /// 转换为一个自定义数据类型的Single
    public func mapCommonObjectData<T: Mappable>() -> Single<T>{
        return flatMap { response -> Single<T> in
            return Single.just( try response.mapCommonModel() )
        }
    }
    
    /// 转换为一个空数据类型<包装>的Single
    public func mapEmptyData() -> Single<ResponseEmptyModel> {
        return mapCommonObjectData()
    }
    
    /// 转换为一个原始类型<包装>的Single
    public func mapOriginalModel<T>() -> Single<ResponseOriginalModel<T>> {
        return mapCommonObjectData()
    }
    
    /// 转换为一个空数据类型<包装>的Single
    public func mapObjectModel<T : Mappable>() -> Single<ResponseObjectModel<T>> {
        return mapCommonObjectData()
    }
    
     /// 转换为一个遵循Mappable的数据对象类型<包装>的Single
    public func mapArrayModel<T : Mappable>() -> Single<ResponseArrayModel<T>> {
        return mapCommonObjectData()
    }
    
    public func mapCommonModelResult<T: Mappable>() -> Observable< ResponseCommonObjectResult<T> >{
        return mapCommonObjectData().asObservable().map({
            return ResponseCommonObjectResult.init(value: $0)
        }).catchError({
            return Observable.just( ResponseCommonObjectResult.init(error: AnyError($0)) )
        })
    }
    
    /// 转换为一个 Result<自定义数据类型, AnyError>
    public func mapEmptyModelResult() -> Observable<ResponseEmptyModelResult>{
        return mapCommonModelResult()
    }
    
    /// 转换为一个 Result<ResponseOriginalModel<Type>, AnyError>
    public func mapOriginalModelResult<T>() -> Observable<ResponseOriginalModelResult<T>>{
        return mapCommonModelResult()
    }
    
    /// 转换为一个 Result<ResponseObjectModel<Type>, AnyError>
    public func mapObjectModelResult<T: Mappable>() -> Observable<ResponseObjectModelResult<T>>{
        return mapCommonModelResult()
    }
    
    /// 转换为一个 Result<ResponseArrayModel<Type>, AnyError>
    public func mapArrayModelResult<T: Mappable>() -> Observable<ResponseArrayModelResult<T>>{
       return mapCommonModelResult()
    }
    
}

