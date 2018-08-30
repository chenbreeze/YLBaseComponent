//
//  ViewController+Load.swift
//  BaseComponent
//
//  Created by chenxiaofeng on 2018/1/19.
//  Copyright © 2018年 张强. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import RxSwift
import RxCocoa
import Moya


/// 加载数据失败原因
///
/// - network: 无网络
/// - server: 服务器失败
public enum LoadDataFailedReason{
    case network
    case server
}

fileprivate struct AssociatedKeys{
    static var SocketLoadingView: UInt8 = 0
    static var ServerCrashView: UInt8 = 0
    static var NoNetworkView: UInt8 = 0
    static var CircleLoadingView: UInt8 = 0
    static var SocketLoadingBinder: UInt8 = 0
    static var CircleLoadingBinder: UInt8 = 0
}





/// 请求数据 with 页面动画
public protocol RequestWithPageAnimation : class{
    func requestData()
    func requestFailedView(error: Error) -> ReRequestableView
}


public extension RequestWithPageAnimation where Self: UIViewController{
    
    internal var socketLoadingView: SocketLoadingView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.SocketLoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: SocketLoadingView? = objc_getAssociatedObject(self, &AssociatedKeys.SocketLoadingView) as? SocketLoadingView
            return obj
        }
    }
    
    internal var serverCrashView: ServerCrashView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ServerCrashView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: ServerCrashView? = objc_getAssociatedObject(self, &AssociatedKeys.ServerCrashView) as? ServerCrashView
            return obj
        }
    }
    
    internal var noNetworkView: NoNetworkView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.NoNetworkView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: NoNetworkView? = objc_getAssociatedObject(self, &AssociatedKeys.NoNetworkView) as? NoNetworkView
            return obj
        }
    }
    
    var SocketLoadingBinder: Binder<RequestState>{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.SocketLoadingBinder, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            var obj: Binder<RequestState>? = objc_getAssociatedObject(self, &AssociatedKeys.SocketLoadingBinder) as? Binder<RequestState>
            
            if obj == nil{
               obj = makeSocketLoadingBinder()
            }
            
            return obj!
        }
    }
    
    private func makeSocketLoadingBinder() -> Binder<RequestState>{
       return Binder<RequestState>(self) { (vc, state)  in
            switch state{
            case .idle:
                break
            case .loading:
                vc.startLoading()
                vc.view.endEditing(true)
            case .success( _):
                vc.loadDataSuccess()
            case .failure(let error, _):
                
                if let err = error as? MoyaError{
                    switch err{
                    case .underlying(_, _):
                        self.loadDataFailed(reason: .network)
                    default :
                        self.loadDataFailed(reason: .server)
                    }
                }else{
                    self.loadDataFailed(reason: .server)
                }
            }
        }
    }
    
    public func startLoading() -> Void{
        
        if let view = socketLoadingView{
            self.view.bringSubview(toFront: view)
        }else{
            socketLoadingView = SocketLoadingView()
            self.view.addSubview(socketLoadingView!)
            
            if self.view.isKind(of: UIScrollView.self){
                socketLoadingView?.frame = self.view.bounds
            }else{
                socketLoadingView!.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
                })

            }
            
        }
    }
    
    public func loadDataSuccess() -> Void{
        /// 加载完成后 不会再需要相关view 全部删除
        if let view = socketLoadingView{
            view.removeFromSuperview()
            socketLoadingView = nil
        }
        
        if let view = serverCrashView{
            view.removeFromSuperview()
            serverCrashView = nil
        }
        
        if let view = noNetworkView{
            view.removeFromSuperview()
            noNetworkView = nil
        }
        
    }
    
    public func loadDataFailed(error: Error){
        if let err = error as? MoyaError{
            switch err{
            case .underlying(_, _):
               loadDataFailed(reason: .network)
            default :
               loadDataFailed(reason: .server)
            }
        }else{
            loadDataFailed(reason: .server)
        }
    }
    
    public func loadDataFailed(reason : LoadDataFailedReason){
        switch reason {
        case .network:
            if let view = noNetworkView{
                self.view.bringSubview(toFront: view)
            }else{
                noNetworkView = NoNetworkView()
                noNetworkView?.refreshClosure = {
                    self.requestData()
                }
                self.view.addSubview(noNetworkView!)
                
                if self.view.isKind(of: UIScrollView.self){
                    noNetworkView?.frame = self.view.bounds
                }else{
                    noNetworkView!.snp.makeConstraints({ (make) in
                        make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
                    })
                }
                
            
            }
            
        case .server:
            if let view = serverCrashView{
                self.view.bringSubview(toFront: view)
            }else{
                serverCrashView = ServerCrashView()
                serverCrashView?.refreshClosure = {
                    self.requestData()
                }
                self.view.addSubview(serverCrashView!)
                
                if self.view.isKind(of: UIScrollView.self){
                    serverCrashView?.frame = self.view.bounds
                }else{
                    serverCrashView!.snp.makeConstraints({ (make) in
                        make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
                    })
                }
                
            }
        }
    }
    
}

public extension UIViewController{
    internal var circleLoadingView: CircleLoadingView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.CircleLoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: CircleLoadingView? = objc_getAssociatedObject(self, &AssociatedKeys.CircleLoadingView) as? CircleLoadingView
            return obj
        }
    }
        
    public func showHudLoadingView() -> Void{
        
        if let view = circleLoadingView{
            view.isHidden = false
            self.view.bringSubview(toFront: view)
        }else{
            circleLoadingView = CircleLoadingView()
            self.view.addSubview(circleLoadingView!)
            
            if self.view.isKind(of: UIScrollView.self){
                circleLoadingView?.frame = self.view.bounds
            }else{
                circleLoadingView!.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
                })
            }
            
            
        }
    }
    
   public func hideHudLoadingView() -> Void{
        if let view = circleLoadingView {
            view.isHidden = true
        }
    }
    
   var HudLoadingBinder: Binder<RequestState>{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.CircleLoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            var obj: Binder<RequestState>? = objc_getAssociatedObject(self, &AssociatedKeys.CircleLoadingView) as? Binder<RequestState>
            
            if obj == nil{
                obj = makeHudLoadingBinder()
            }
            
            return obj!
        }
    }
    
     private func makeHudLoadingBinder() -> Binder<RequestState>{
     
        return  Binder<RequestState>(self) { (vc, state)  in
            switch state{
            case .idle:
                vc.hideHudLoadingView()
            case .loading:
                vc.showHudLoadingView()
                vc.view.endEditing(true)
            case .success(let msg):
                 vc.hideHudLoadingView()
            case .failure(let error, let msg):
                 vc.hideHudLoadingView()
            }
        }
    }
}


