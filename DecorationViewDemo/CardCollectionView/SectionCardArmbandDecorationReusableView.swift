//
//  SectionCardArmbandDecorationReusableView.swift
//  DecorationViewDemo
//
//  Created by York on 2018/5/20.
//  Copyright © 2018年 YK-Unit. All rights reserved.
//

import Foundation
import UIKit

/// section卡片袖标的布局属性
class SectionCardArmbandDecorationCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    // 袖标图片
    var imageName: String?

    //所定义属性的类型需要遵从 NSCopying 协议
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SectionCardArmbandDecorationCollectionViewLayoutAttributes
        copy.imageName = self.imageName
        return copy
    }

    //所定义属性的类型还要实现相等判断方法（isEqual）
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SectionCardArmbandDecorationCollectionViewLayoutAttributes else {
            return false
        }

        if self.imageName != rhs.imageName {
            return false
        }
        return super.isEqual(object)
    }
}

/// section卡片袖标装饰图
class SectionCardArmbandDecorationReusableView: UICollectionReusableView {

    /// 袖标icon视图
    private let armbandImageView = UIImageView()

    override init(frame: CGRect) {
        let newFrame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: 80, height: 53)
        super.init(frame: newFrame)
        self.customInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customInit()
    }

    func customInit() {
        self.backgroundColor = UIColor.clear

        armbandImageView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 53)
        armbandImageView.contentMode = .scaleAspectFit
        self.addSubview(armbandImageView)
    }

    //通过apply方法让自定义属性生效
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attr = layoutAttributes as? SectionCardArmbandDecorationCollectionViewLayoutAttributes else {
            return
        }

        guard let imageName = attr.imageName else {
            self.armbandImageView.image = nil
            return
        }

        self.armbandImageView.image = UIImage.init(named: imageName)
    }
}

let SectionCardArmbandDecorationViewKind = "SectionCardArmbandDecorationReuseIdentifier"
