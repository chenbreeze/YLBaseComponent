# Swift 基础可复用类库

 * 网络库  封装Moya+ObjectMapper 及扩展
 
   + 扩展Moya.Response，通过泛型和ObjectMapper增数加据映射功能, 并扩展相应Rx
   
     ```
     // 调用
       let provider = MoyaProvider<YLTestApi>().rx
       let sequence = provider.request(.home).mapCommonModelResult() as Observable<ResponseCommonObjectResult<YLTestModel>>
       let single = provider.request(.home).mapCommonObjectData() as Single<YLTestModel>
      
     ```
   + 扩展TargetType协议，封装MoyaProvider 1  YLTargetType+DataProvider
   
     ```
      // 调用
        let provider = DataProvider<YLTestApi>().
        let sequence1 = provider.rx.requestModel(.home)
        let sequence2 = provider.rx.requestResult(.home)
     ```
    + 扩展TargetType协议，封装MoyaProvider 2 XLTargetType+XLProvider
    
      ```
       // 调用
        let provider = XLProvider<XLTestApi>()
        let userSequence = provider.rx.requestResult(.user) as Observable<XLRequestResult<XLTestModel>>
      ```
