//
//  RefreshProtocolDemo.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/9/1.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh


class Controller: UIViewController {
    let scroll = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        
        // this automic create heafer&footer
        self.dropDownLoadHanlder = pullRefresh
        self.pullLoadMoreHanlder = loadMoreData
    }
    
    private func pullRefresh(){
        
    }
    
    private func loadMoreData(){
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scroll.frame = view.bounds
    }
    
}

extension Controller: Refreshable{
    var scrollView: UIScrollView {
        return self.scroll
    }
}

// change view style to type1
extension Controller: RefreshViewType1{}

// change view style to type2
//extension Controller: RefreshViewType2{}

// also
protocol RefreshViewType1 {}

protocol RefreshViewType2 {}


extension Refreshable where Self: RefreshViewType1{
    
    func mjRefreshHeader(hanlder: @escaping RefreshHanlder) -> MJRefreshHeader{
        // 创建自定义header
        fatalError()
    }
    
    func mjRefreshFooter(hanlder: @escaping RefreshHanlder) -> MJRefreshFooter{
        // 创建自定义footer
        fatalError()
    }
}

extension Refreshable where Self: RefreshViewType2{
    
    func mjRefreshHeader(hanlder: @escaping RefreshHanlder) -> MJRefreshHeader{
        // 创建自定义header
        fatalError()
    }
    
    func mjRefreshFooter(hanlder: @escaping RefreshHanlder) -> MJRefreshFooter{
        // 创建自定义footer
        fatalError()
    }
}
