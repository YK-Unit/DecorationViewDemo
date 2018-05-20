//
//  SectionCardDecorationCollectionViewLayout.swift
//  DecorationViewDemo
//
//  Created by York on 2018/5/19.
//  Copyright © 2018年 YK-Unit. All rights reserved.
//

import Foundation
import UIKit

protocol SectionCardDecorationCollectionViewLayoutDelegate: NSObjectProtocol {

    /// 指定section是否显示卡片装饰图，默认值为false
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationDisplayedForSectionAt section: Int) -> Bool

    /// 指定section卡片装饰图颜色，默认为白色
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationColorForSectionAt section: Int) -> UIColor

    /// 指定section卡片装饰图间距
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationInsetForSectionAt section: Int) -> UIEdgeInsets

    /// 指定section卡片装饰图是否显示袖标，默认值为false
    /// - Note: 若卡片装饰图不显示，袖标就算是true，也不显示
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationDisplayedForSectionAt section: Int) -> Bool

    /// 指定section的袖标图标本地图片名字，默认为nil
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationImageForSectionAt section: Int) -> String?

    /// 指定section的袖标距离卡片的TopOffsetp
    /// - Note: 值为nil时，使用默认值18
    ///
    /// - Parameters:
    ///   - collectionView: <#collectionView description#>
    ///   - collectionViewLayout: <#collectionViewLayout description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationTopOffsetForSectionAt section: Int) -> CGFloat?
}

extension SectionCardDecorationCollectionViewLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationDisplayedForSectionAt section: Int) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationInsetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationDisplayedForSectionAt section: Int) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationImageForSectionAt section: Int) -> String? {
        return nil
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationTopOffsetForSectionAt section: Int) -> CGFloat? {
        return nil
    }
}

/// 卡片式背景CollectionViewLayout
class SectionCardDecorationCollectionViewLayout: UICollectionViewFlowLayout {

    //保存所有自定义的section背景的布局属性
    private var cardDecorationViewAttrs: [Int:UICollectionViewLayoutAttributes] = [:]
    private var armbandDecorationViewAttrs: [Int:UICollectionViewLayoutAttributes] = [:]

    public weak var decorationDelegate: SectionCardDecorationCollectionViewLayoutDelegate?

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    //初始化时进行一些注册操作
    func setup() {
        //注册DecorationView
        self.register(SectionCardDecorationReusableView.self,
                      forDecorationViewOfKind: SectionCardDecorationViewKind)

        self.register(SectionCardArmbandDecorationReusableView.self,
                      forDecorationViewOfKind: SectionCardArmbandDecorationViewKind)
    }

    override func prepare() {
        super.prepare()

        // 如果collectionView当前没有分区，则直接退出
        guard let numberOfSections = self.collectionView?.numberOfSections
            else {
                return
        }

        let flowLayoutDelegate: UICollectionViewDelegateFlowLayout? = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout

        // 不存在cardDecorationDelegate就退出
        guard let strongCardDecorationDelegate = decorationDelegate else {
            return
        }

        // 删除旧的装饰视图的布局数据
        self.cardDecorationViewAttrs.removeAll()
        self.armbandDecorationViewAttrs.removeAll()

        //分别计算每个section的装饰视图的布局属性
        for section in 0..<numberOfSections {
            //获取该section下第一个，以及最后一个item的布局属性
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at:
                    IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at:
                    IndexPath(item: numberOfItems - 1, section: section))
                else {
                    continue
            }

            //获取该section的内边距
            var sectionInset = self.sectionInset
            if let inset = flowLayoutDelegate?.collectionView?(self.collectionView!,
                                                              layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }

            //计算得到该section实际的位置
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            //计算得到该section实际的尺寸
            if self.scrollDirection == .horizontal {
                sectionFrame.origin.x -= sectionInset.left
                sectionFrame.origin.y = sectionInset.top
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.origin.x = sectionInset.left
                sectionFrame.origin.y -= sectionInset.top
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }


            // 想判断卡片是否可见
            let cardDisplayed = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, decorationDisplayedForSectionAt: section)
            guard cardDisplayed == true else {
                continue
            }

            // 计算卡片装饰图的属性
            let cardDecorationInset = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, decorationInsetForSectionAt: section)
            //计算得到cardDecoration该实际的尺寸
            var cardDecorationFrame = sectionFrame
            if self.scrollDirection == .horizontal {
                cardDecorationFrame.origin.x = sectionFrame.origin.x + cardDecorationInset.left
                cardDecorationFrame.origin.y = cardDecorationInset.top
            } else {
                cardDecorationFrame.origin.x = cardDecorationInset.left
                cardDecorationFrame.origin.y = sectionFrame.origin.y + cardDecorationInset.top
            }
            cardDecorationFrame.size.width = sectionFrame.size.width - (cardDecorationInset.left + cardDecorationInset.right)
            cardDecorationFrame.size.height = sectionFrame.size.height - (cardDecorationInset.top + cardDecorationInset.bottom)

            //根据上面的结果计算卡片装饰图的布局属性
            let cardAttr = SectionCardDecorationCollectionViewLayoutAttributes(
                forDecorationViewOfKind: SectionCardDecorationViewKind,
                with: IndexPath(item: 0, section: section))
            cardAttr.frame = cardDecorationFrame

            // zIndex用于设置front-to-back层级；值越大，优先布局在上层；cell的zIndex为0
            cardAttr.zIndex = -1
            //通过代理方法获取该section卡片装饰图使用的颜色
            let backgroundColor = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, decorationColorForSectionAt: section)
            cardAttr.backgroundColor = backgroundColor

            //将该section的卡片装饰图的布局属性保存起来
            self.cardDecorationViewAttrs[section] = cardAttr


            // 先判断袖标是否可见
            let armbandDisplayed = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, armbandDecorationDisplayedForSectionAt: section)
            guard armbandDisplayed == true else {
                continue
            }

            // 如果袖标图片名称为nil，就跳过
            guard let imageName = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, armbandDecorationImageForSectionAt: section) else {
                continue
            }

            // 计算袖标装饰图的属性
            var armbandDecorationInset = cardDecorationInset
            armbandDecorationInset.left = 1
            armbandDecorationInset.top = 18
            if let topOffset = strongCardDecorationDelegate.collectionView(self.collectionView!, layout: self, armbandDecorationTopOffsetForSectionAt: section) {
                armbandDecorationInset.top = topOffset
            }
            //计算得到armbandDecoration该实际的尺寸
            var armbandDecorationFrame = sectionFrame
            if self.scrollDirection == .horizontal {
                armbandDecorationFrame.origin.x = sectionFrame.origin.x + armbandDecorationInset.left
                armbandDecorationFrame.origin.y = armbandDecorationInset.top
            } else {
                armbandDecorationFrame.origin.x = armbandDecorationInset.left
                armbandDecorationFrame.origin.y = sectionFrame.origin.y + armbandDecorationInset.top
            }
            armbandDecorationFrame.size.width = 80
            armbandDecorationFrame.size.height = 53

            // 根据上面的结果计算袖标装饰视图的布局属性
            let armbandAttr = SectionCardArmbandDecorationCollectionViewLayoutAttributes(
                forDecorationViewOfKind: SectionCardArmbandDecorationViewKind,
                with: IndexPath(item: 0, section: section))
            armbandAttr.frame = armbandDecorationFrame
            armbandAttr.zIndex = 1
            armbandAttr.imageName = imageName
            //将该section的袖标装饰视图的布局属性保存起来
            self.armbandDecorationViewAttrs[section] = armbandAttr
        }
    }

    //返回rect范围下父类的所有元素的布局属性以及子类自定义装饰视图的布局属性
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var attrs = super.layoutAttributesForElements(in: rect)
            attrs?.append(contentsOf: self.cardDecorationViewAttrs.values.filter {
                return rect.intersects($0.frame)
            })
            attrs?.append(contentsOf: self.armbandDecorationViewAttrs.values.filter {
                return rect.intersects($0.frame)
            })
            return attrs
    }

    //返回对应于indexPath的位置的装饰视图的布局属性
    override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                    at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        if elementKind == SectionCardDecorationViewKind {
            return self.cardDecorationViewAttrs[section]
        } else if elementKind == SectionCardArmbandDecorationViewKind {
            return self.armbandDecorationViewAttrs[section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind,
                                                       at: indexPath)
    }
}
