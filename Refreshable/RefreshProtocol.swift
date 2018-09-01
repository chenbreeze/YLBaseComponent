//
//  RefreshProtocol.swift
//  YLBaseComponent
//
//  Created by chenxiaofeng on 2018/8/31.
//  Copyright © 2018年 xuanlv.cgs.com. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

protocol Scrollable {
    var scrollView: UIScrollView  { get }
}

protocol Refreshable:class, Scrollable {
    
    typealias RefreshHanlder = () -> Void
    
    func mjRefreshHeader(hanlder: @escaping RefreshHanlder) -> MJRefreshHeader
    func mjRefreshFooter(hanlder: @escaping RefreshHanlder) -> MJRefreshFooter
    
}

extension Refreshable{
    
    var dropDownLoadHanlder: RefreshHanlder? {
        get{
            return self.scrollView.mj_header.refreshingBlock
        }
        
        set{
            if let hanlder = newValue{
                self.scrollView.mj_header = self.mjRefreshHeader(hanlder: hanlder)
            }else{
                self.scrollView.mj_header = nil
            }
        }
    }
    
    var pullLoadMoreHanlder: RefreshHanlder? {
        get{
            return self.scrollView.mj_footer.refreshingBlock
        }
        
        set{
            
            if let hanlder = newValue{
                self.scrollView.mj_footer = self.mjRefreshFooter(hanlder: hanlder)
            }else{
                self.scrollView.mj_footer = nil
            }
        }
    }
    
    // default imp
    func mjRefreshHeader(hanlder: @escaping RefreshHanlder) -> MJRefreshHeader{
        return MJRefreshNormalHeader(refreshingBlock: hanlder)
    }
    
    
    func mjRefreshFooter(hanlder: @escaping RefreshHanlder) -> MJRefreshFooter{
        return MJRefreshBackNormalFooter(refreshingBlock: hanlder)
    }
}



