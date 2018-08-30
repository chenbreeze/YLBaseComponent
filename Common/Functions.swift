//
//  Functions.swift
//  BMBuyer
//
//  Created by chenxiaofeng on 2018/6/4.
//  Copyright © 2018年 shencai.cgs.com. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

///只在debug环境下打印, 携带文件及函数信息
public func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: StaticString = #file, line: UInt = #line, function: StaticString = #function){
    
    
    #if DEBUG
    
    if let lastPath = file.description.components(separatedBy: "/").last{
        print("\(lastPath) func:\(function) line:\(line)", separator: "", terminator: ":  ")
    }else{
        print("\(file) func:\(function) line:\(line)", separator: "", terminator: ":  ")
    }
    
    items.forEach { (item) in
        print(item, separator: "", terminator: "")
        print(separator, separator: "", terminator: "")
    }
    
    print(terminator, separator: "", terminator: "")
    
    #endif
}


/// 自适应的宽度
///
/// - Parameter width: original width
/// - Returns: adpative width
public func AutoWidth(_ width: CGFloat) -> CGFloat{
    return width / 375.0 * ScreenWidth
}


/// 自适应的高度
///
/// - Parameter height: original height
/// - Returns: adpative height
public func AutoHeight(_ height: CGFloat) -> CGFloat{
    return height / 667.0 * ScreenHeight
}


/// 播放滴滴声
public func PlayNoticeSound(){
    
    let fileUrl = NSURL.init(string: "/System/Library/Audio/UISounds/sms-received1.caf")!
    var sound  : SystemSoundID = 1
    _ =  AudioServicesCreateSystemSoundID(fileUrl, &sound)
    
    AudioServicesPlayAlertSoundWithCompletion(sound, nil)
}


/// 震动
public func VibratePhone(){
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
}

/// 压缩图片
public func CompressImageData(_ data: Data, to maxSize: Int) -> Data{
    
    guard data.count > maxSize else {
        return data
    }
    
    let quality: Float = Float(maxSize) / Float (data.count) * 0.9
    
    return UIImageJPEGRepresentation(UIImage(data: data)!, CGFloat(quality))!
}



