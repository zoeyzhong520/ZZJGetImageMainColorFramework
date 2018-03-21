//
//  ZZJGetImageMainColorTool.swift
//  ZZJGetImageMainColorFramework
//
//  Created by ZHONG ZHAOJUN on 2018/3/21.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class ZZJGetImageMainColorTool: NSObject {

    ///根据图片获取 UIImage 的主色调
    /// - Parameters:
    ///   - image: 图片
    class func getImageMainColor(withImage image: UIImage) -> UIColor {
        
        let bitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.last.rawValue)
        
        //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
        let thumbSize = CGSize(width: image.size.width / 2, height: image.size.height / 2)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: nil, width: Int(thumbSize.width), height: Int(thumbSize.height), bitsPerComponent: 8, bytesPerRow: Int(thumbSize.width * CGFloat(4)), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        context?.draw(image.cgImage!, in: drawRect)
        
        
    }
}




















