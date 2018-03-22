//
//  common.swift
//  ZZJGetImageMainColorFramework
//
//  Created by JOE on 2018/3/22.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

///RGBA
let RGBA: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = { r, g, b, a in
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

