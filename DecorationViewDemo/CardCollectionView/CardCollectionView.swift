//
//  CardCollectionView.swift
//  DecorationViewDemo
//
//  Created by York on 2018/5/19.
//  Copyright © 2018年 YK-Unit. All rights reserved.
//

import UIKit

// 定制化的UICollectionView
//
// Q：为什么需要这样一个CardCollectionView
//
// A：因为element attributes z-index 失效了，具体表现为，虽然设定了decorationView的zIndex小于cell的，但是在iOS10+以上，UICollectionView在布局时，会随机出现有些cell是在decorationView后面，具体可以参考：https://github.com/lionheart/openradar-mirror/issues/15453
class CardCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()

        // 手动调整卡片视图和cell的层级关系
        var sectionCardViews: [UIView] = []

        self.subviews.forEach { (subview) in
            if let decorationView = subview as? SectionCardDecorationReusableView {
                sectionCardViews.append(decorationView)
            }
        }

        sectionCardViews.forEach { (decorationView) in
            self.sendSubview(toBack: decorationView)
        }
    }
}
