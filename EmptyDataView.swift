//
//  EmptyDataView.swift
//  operation4ios
//
//  Created by sungrow on 2017/2/28.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {

    var contentText: String = NSLocalizedString("暂无数据", comment: "") {
        didSet {
            contentTextLabel.text = contentText
        }
    }
    var contentImage: UIImage = #imageLiteral(resourceName: "placeholder_airbnb") {
        didSet {
            contentImageView.image = contentImage
        }
    }
    
    var clickAction: (() -> Void)?
    
    // MARK:- 控件
    fileprivate lazy var contentImageView: UIImageView = UIImageView()
    fileprivate lazy var contentTextLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let clickAction = clickAction {
            clickAction()
        }
    }

}

// MARK:-  private func
extension EmptyDataView {
    // MARK:- UI
    fileprivate func createUI() {
        isHidden = true
        addSubview(contentImageView)
        addSubview(contentTextLabel)
        
        contentTextLabel.text = contentText
        contentTextLabel.textAlignment = .center
        contentTextLabel.textColor = UIColor.lightGray
        contentImageView.image = contentImage
        
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentImageViewCenterX = NSLayoutConstraint.init(item: contentImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let contentImageViewCenterY = NSLayoutConstraint.init(item: contentImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -80)
        self.addConstraints([contentImageViewCenterX, contentImageViewCenterY]);
        
        let contentTextLabelTop = NSLayoutConstraint.init(item: contentTextLabel, attribute: .top, relatedBy: .equal, toItem: contentImageView, attribute: .bottom, multiplier: 1, constant: 16)
        let contentTextLabelViewCenterXs = NSLayoutConstraint.init(item: contentTextLabel, attribute: .centerX, relatedBy: .equal, toItem: contentImageView, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraints([contentTextLabelTop, contentTextLabelViewCenterXs]);
    }
}
