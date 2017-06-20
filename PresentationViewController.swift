//
//  PresentationViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/27.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class PresentationViewController: UIPresentationController {
    
    lazy var containerViewFrame: CGRect = CGRect.zero
    // MARK:- 懒加载属性
    fileprivate lazy var maskerView: UIView = UIView()
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
         super.containerViewWillLayoutSubviews()
        //1.设置弹出的尺寸
        presentedView?.frame = containerViewFrame
        //2.添加蒙版
        setupMaskerView()
    }
}

//MARK:- 设置UI界面相关
extension PresentationViewController {
    fileprivate func setupMaskerView() {
        containerView?.insertSubview(maskerView, at: 0)
        maskerView.frame = (containerView?.bounds)!
        maskerView.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(PresentationViewController.tapAction))
        maskerView.addGestureRecognizer(tap)
    }
}

//MARK:- 事件监听
extension PresentationViewController {
    @objc fileprivate func tapAction() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}




