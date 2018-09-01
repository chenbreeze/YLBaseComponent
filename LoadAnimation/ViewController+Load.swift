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

fileprivate struct PageAssociatedKeys{
    static var LoadingView: UInt8 = 0
    static var FailedView: UInt8 = 0
    static var Binder: UInt8 = 0
}


public extension PageRequestable where Self: UIViewController{
    
    private var loadingView: UIView? {
        set {
            objc_setAssociatedObject(self, &PageAssociatedKeys.LoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: UIView? = objc_getAssociatedObject(self, &PageAssociatedKeys.LoadingView) as? UIView
            return obj
        }
    }
    
    private var failedView: ReRequestableView? {
        set {
            objc_setAssociatedObject(self, &PageAssociatedKeys.FailedView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: ReRequestableView? = objc_getAssociatedObject(self, &PageAssociatedKeys.FailedView) as? ReRequestableView
            return obj
        }
    }
    
    
    var LoadingBinder: Binder<RequestState>{
        set{
            objc_setAssociatedObject(self, &PageAssociatedKeys.Binder, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            var obj: Binder<RequestState>? = objc_getAssociatedObject(self, &PageAssociatedKeys.Binder) as? Binder<RequestState>
            
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
                vc.startPageLoading()
                vc.view.endEditing(true)
            case .success( _):
                vc.loadDataSuccess()
            case .failure(let error, _):
                vc.loadDataFailed(error: error)
            }
        }
    }
    
    public func startPageLoading() -> Void{
        
        if let view = failedView?.realView{
            view.removeFromSuperview()
            failedView = nil
        }
        
        loadingView = self.pageLoadingView()
        self.view.addSubview(loadingView!)
        self.layoutLoadingView(loadingView!)
    }
    
    public func loadDataSuccess() -> Void{
        /// 加载完成后 不会再需要相关view 全部删除
        if let view = loadingView{
            view.removeFromSuperview()
            loadingView = nil
        }
        
        if let view = failedView?.realView{
            view.removeFromSuperview()
            failedView = nil
        }
    }
    
    public func loadDataFailed(error: Error){
        let reReauest = self.requestFailedView(error: error)
        let failedView = reReauest.realView
        self.view.addSubview(failedView)
        
        self.layoutFailedView(reReauest)
        
        reReauest.request = {
            self.requestData()
        }
        self.failedView = reReauest
    }
    
    
    // default imp
    public func pageLoadingView() -> UIView {
        return SocketLoadingView()
    }
    
    public func requestFailedView(error: Error) -> ReRequestableView{
        
        if let err = error as? MoyaError{
            switch err{
            case .underlying(_, _):
                return NoNetworkView()
            default :
                return ServerCrashView()
            }
        }else{
            return ServerCrashView()
        }
        
    }
    
    public func layoutFailedView(_ view: ReRequestableView){
        let failedView = view.realView
        if failedView.isKind(of: UIScrollView.self){
            failedView.frame = self.view.bounds
        }else{
            failedView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
            })
        }
    }
    
    public func layoutLoadingView(_ view: UIView) -> Void{
        if self.view.isKind(of: UIScrollView.self){
            view.frame = self.view.bounds
        }else{
            view.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
            })
        }
    }
}


fileprivate struct HudAssociatedKeys{
    static var LoadingView: UInt8 = 0
    static var Binder: UInt8 = 0
}

public extension HudRequestable where Self: Viewable{
    
    private var loadingView: UIView? {
        set {
            objc_setAssociatedObject(self, &HudAssociatedKeys.LoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get {
            let obj: UIView? = objc_getAssociatedObject(self, &HudAssociatedKeys.LoadingView) as? UIView
            return obj
        }
    }
    
    public var showHudLoadingView: Bool {
        get{
            if let view = loadingView{
                return view.isHidden
            }else{
                return false
            }
        }
        
        set{
            
            if let view = loadingView{
                view.isHidden = newValue
            }else{
                let view = self.hudLoadingView()
                self.realView.addSubview(view)
                self.layoutHudLoadingView(view)
                loadingView = view
            }
        }
    }
    
    func hudLoadingView() -> UIView{
        // for UIViewController
        return CircleLoadingView()
        // for UIView
        // return UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }
    
    
    func layoutHudLoadingView(_ view: UIView){
        if self.realView.isKind(of: UIScrollView.self){
            view.frame = self.realView.bounds
        }else{
            view.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.realView).inset(UIEdgeInsets.zero)
            })
        }
    }
   
    
    var showHudLoadingBinder: Binder<Bool>{
        
        set{
            objc_setAssociatedObject(self, &HudAssociatedKeys.LoadingView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            var obj: Binder<Bool>? = objc_getAssociatedObject(self, &HudAssociatedKeys.LoadingView) as? Binder<Bool>
            
            if obj == nil{
                obj = makeHudLoadingBinder()
            }
            
            return obj!
        }
    }
    
    private func makeHudLoadingBinder() -> Binder<Bool>{
        
        return Binder<Bool>.init(self, binding: { (vc, result) in
            vc.showHudLoadingView = result
        })
        
    }
}

extension UIViewController: Viewable{
    public var realView: UIView {
        return self.view
    }
}

extension UIView: Viewable{
    public var realView: UIView {
        return self
    }
}

extension UIViewController: HudRequestable {}

extension UIView: HudRequestable {}
