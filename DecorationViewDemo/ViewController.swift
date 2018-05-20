//
//  ViewController.swift
//  DecorationViewDemo
//
//  Created by York on 2018/5/19.
//  Copyright © 2018年 YK-Unit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let cellReuseIdentifier = "cellReuseIdentifier"

    private var collectionView: CardCollectionView!

    private var dataValue = 0
    private var dataArray: [[Int]] = [[1,2,3],[1,2,3],[1,2,3]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initView() {

        let button = UIButton.init(frame: CGRect.init(x: 10, y: 60, width: 100, height: 20))
        button.setTitle("更新数据源", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(updateData(_:)), for: .touchUpInside)
        view.addSubview(button)

        let cardLayout = SectionCardDecorationCollectionViewLayout.init()
        cardLayout.decorationDelegate = self
        cardLayout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        cardLayout.minimumLineSpacing = 5
        cardLayout.minimumInteritemSpacing = 0
        cardLayout.itemSize = CGSize.init(width: view.bounds.width - 30, height: 50)
        collectionView = CardCollectionView(frame: CGRect.init(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100), collectionViewLayout: cardLayout)
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        view.addSubview(collectionView)

        collectionView.reloadData()
    }

    @objc private func updateData(_ sender: Any) {
        dataValue += 1

        if dataValue % 2 == 0 {
            dataArray =  [
                [1,2,3],
                [1,2,3],
                [1,2,3],
            ]
        } else {
            dataArray =  [
                [1,2,3],
                [1,2,3],
                [1,2,3],
                [1,2,3],
                [1,2,3]
            ]
        }

        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < dataArray.count {
            let subArray = dataArray[section]
            return subArray.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)

        cell.backgroundColor = UIColor.green

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt--(\(indexPath.section),\(indexPath.row))")
    }

}

extension ViewController: SectionCardDecorationCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationDisplayedForSectionAt section: Int) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationColorForSectionAt section: Int) -> UIColor {
        return UIColor.blue
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        decorationInsetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationDisplayedForSectionAt section: Int) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationImageForSectionAt section: Int) -> String? {
        return "armband"
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: SectionCardDecorationCollectionViewLayout,
                        armbandDecorationTopOffsetForSectionAt section: Int) -> CGFloat? {
        return 18
    }
}

