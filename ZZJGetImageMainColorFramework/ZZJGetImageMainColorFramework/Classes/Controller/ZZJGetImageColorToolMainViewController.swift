//
//  ZZJGetImageColorToolMainViewController.swift
//  ZZJGetImageMainColorFramework
//
//  Created by ZHONG ZHAOJUN on 2018/3/21.
//  Copyright © 2018年 ZHONG ZHAOJUN. All rights reserved.
//

import UIKit

class ZZJGetImageColorToolMainViewController: BaseViewController {
    
    ///图片数组
    lazy var imagesArray:Array<String> = {
        var imagesArray = [String]()
        for i in 0..<6 {
            imagesArray.append("\(i + 1).jpg")
        }
        return imagesArray
    }()
    
    ///间隙
    var margin:CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ZZJGetImageColorToolMainViewController {
    
    fileprivate func setPage() {
        
        self.addClearCachesButtonView()
        self.addSquaredView()
    }
    
    ///清除缓存按钮
    fileprivate func addClearCachesButtonView() {
        
        let rightButton = UIBarButtonItem(title: "清除缓存", style: .plain, target: self, action: #selector(clearCachesButtonAction))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc fileprivate func clearCachesButtonAction() {
        
        guard let domins = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: domins)
        UserDefaults.standard.synchronize()
        
        //重置背景颜色
        self.view.backgroundColor = UIColor.white
        
        print("清除缓存")
    }
    
    ///六宫格
    fileprivate func addSquaredView() {
        
        for i in 0..<imagesArray.count {
            let w:CGFloat = (UIScreen.main.bounds.size.width - margin * 4) / 3 //宽度
            
            //UIImageView
            let imageView = UIImageView(frame: CGRect(x: (w + margin) * CGFloat((i % 3)) + margin, y: (w + margin) * CGFloat((i / 3)) + margin * 8, width: w, height: w))
            imageView.image = UIImage(named: imagesArray[i])
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapAction(recognizer:))))
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            view.addSubview(imageView)
        }
    }
    
    @objc fileprivate func imageViewTapAction(recognizer: UITapGestureRecognizer) {
        
        print(#function)
        guard let tag = recognizer.view?.tag, let imageView = recognizer.view as? UIImageView else { return }
        self.imageMainColor(withImageView: imageView, withTag: tag)
    }
    
    ///获取被点击图片的主色调并修改背景色
    fileprivate func imageMainColor(withImageView imageView: UIImageView, withTag tag: Int) {
        
        guard let image = imageView.image else { return }
        
        let w:CGFloat = (UIScreen.main.bounds.size.width - margin * 4) / 3 //宽度
        
        let key = "imageMainColor\(tag)"
        
        let color = ZZJGetImageMainColorTool.mainColorWithCache(withImage: image, withSize: CGSize(width: w, height: w), withKey: key)
        self.view.backgroundColor = color ?? UIColor.white
    }
}







