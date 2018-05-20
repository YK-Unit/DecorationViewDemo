//
//  SectionCardDecorationCollectionView.swift
//  DecorationViewDemo
//
//  Created by York on 2018/5/20.
//  Copyright © 2018年 YK-Unit. All rights reserved.
//

import Foundation
import UIKit

/// section卡片装饰图的布局属性
class SectionCardDecorationCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    //背景色
    var backgroundColor = UIColor.white

    //所定义属性的类型需要遵从 NSCopying 协议
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! SectionCardDecorationCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }

    //所定义属性的类型还要实现相等判断方法（isEqual）
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SectionCardDecorationCollectionViewLayoutAttributes else {
            return false
        }

        if !self.backgroundColor.isEqual(rhs.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
}

/// Section卡片装饰视图
class SectionCardDecorationReusableView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customInit()
    }

    func customInit() {
        self.backgroundColor = UIColor.white

        self.layer.cornerRadius = 6.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
    }

    //通过apply方法让自定义属性生效
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attr = layoutAttributes as? SectionCardDecorationCollectionViewLayoutAttributes else {
            return
        }

        self.backgroundColor = attr.backgroundColor
    }
}

let SectionCardDecorationViewKind = "SectionCardDecorationReuseIdentifier"
