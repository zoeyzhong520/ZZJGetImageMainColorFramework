//
//  ZZJGetImageMainColorTool.swift
//  ZZJGetImageMainColorFramework
//
//  Created by ZHONG ZHAOJUN on 2018/3/21.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class ZZJGetImageMainColorTool: NSObject {

    //MARK: - 根据图片获取 UIImage 的主色调 -> 私有方法
    ///根据图片获取 UIImage 的主色调
    /// - Parameters:
    ///   - image: 图片
    class fileprivate func getImageMainColor(withImage image: UIImage, withSize size: CGSize) -> [String:CGFloat]? {
        
        let bitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
        let thumbSize = CGSize(width: size.width / 2, height: size.height / 2)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(data: nil, width: Int(thumbSize.width), height: Int(thumbSize.height), bitsPerComponent: 8, bytesPerRow: Int(thumbSize.width) * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)  else {
            print("context is nil")
            return nil
        }
        
        let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        context.draw(image.cgImage!, in: drawRect)
        
        //第二步 取每个点的像素值
        let data = unsafeBitCast(context.data, to: UnsafePointer<CUnsignedChar>.self)
        
        let cls = NSCountedSet.init(capacity: Int(thumbSize.width * thumbSize.height))
        
        for x in 0..<Int(thumbSize.width) {
            for y in 0..<Int(thumbSize.height) {
//                let offSet = 4 * (x + y * Int(thumbSize.width)) //获取精确的主色调
                let offSet = 4 * x * y
                let red = (data + offSet).pointee
                let green = (data + offSet + 1).pointee
                let blue = (data + offSet + 2).pointee
                let alpha = (data + offSet + 3).pointee
                
                if alpha > 0 { //去除透明
                    if !(red == 255 && green == 255 && blue == 255) { //去除白色
                        let clr = NSArray.init(array: [red, green, blue, alpha])
                        cls.add(clr)
                    }
                }
            }
        }
        
        //第三步 找到出现次数最多的那个颜色
        let enumerator = cls.objectEnumerator()
        var maxColor:Array<CGFloat>? = nil
        var maxCount:Int = 0
        
        while let curColor = enumerator.nextObject() {
            let tmpCount = cls.count(for: curColor)
            if tmpCount >= maxCount {
                maxCount = tmpCount
                maxColor = curColor as? Array<CGFloat>
            }
        }
        
        guard let r = maxColor?[0], let g = maxColor?[1], let b = maxColor?[2], let a = maxColor?[3] else { return nil }
        
        return ["r": r, "g": g, "b": b, "a": a]
    }
    
    //MARK: - 从本地缓存查找图片的主色调
    ///从本地缓存查找图片的主色调
    /// - Parameters:
    ///   - image: 图片
    ///   - size: 图片尺寸
    ///   - key: 缓存使用的key
    class func mainColorWithCache(withImage image: UIImage, withSize size: CGSize, withKey key: String) -> UIColor? {
        
        var colorDict = [String:CGFloat]()
        
        if UserDefaults.standard.object(forKey: key) == nil {
            guard let mainColorDict = ZZJGetImageMainColorTool.getImageMainColor(withImage: image, withSize: size) else { return nil }
            colorDict = mainColorDict
        } else {
            colorDict = UserDefaults.standard.object(forKey: key) as! [String:CGFloat]
        }
        
        //把图片主色调存储到本地
        UserDefaults.standard.set(colorDict, forKey: key)
        UserDefaults.standard.synchronize()
        
        guard let r = colorDict["r"], let g = colorDict["g"], let b = colorDict["b"], let a = colorDict["a"] else {
            print("获取图片主色调缓存失败！") //获取失败
            return nil
        }
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a) //获取成功
    }
    
    //MARK: 获取图片的主色调
    ///获取图片的主色调
    /// - Parameters:
    ///   - image: 图片
    ///   - size: 图片尺寸
    class func mainColor(withImage image: UIImage, withSize size: CGSize) -> UIColor? {
        
        guard let mainColorDict = ZZJGetImageMainColorTool.getImageMainColor(withImage: image, withSize: size) else { return nil }
        
        guard let r = mainColorDict["r"], let g = mainColorDict["g"], let b = mainColorDict["b"], let a = mainColorDict["a"] else {
            print("found nil") //获取失败
            return nil
        }
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a) //获取成功
    }
}



