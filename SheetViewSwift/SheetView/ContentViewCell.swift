//
//  ContentViewCell.swift
//  SheetViewSwift
//
//  Created by mengminduan on 2017/9/29.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

import UIKit

class ContentViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    var cellCollectionView: UICollectionView?
    
    var cellForItemAtIndexPathClosure: ((NSIndexPath) -> String)?
    var numberOfItemsInSectionClosure: ((Int) -> Int)?
    var sizeForItemAtIndexPathClosure: ((UICollectionViewLayout?, NSIndexPath) -> CGSize)?
    var ContentViewCellDidScrollClosure: ((UIScrollView) ->Void)?
    var cellWithColorAtIndexPathClosure: ((NSIndexPath) -> Bool)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.cellCollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        self.cellCollectionView?.showsHorizontalScrollIndicator = false
        self.cellCollectionView?.backgroundColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0)
        self.cellCollectionView?.layer.borderColor = self.cellCollectionView?.backgroundColor?.cgColor
        self.cellCollectionView?.layer.borderWidth = 1.0
        self.cellCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "inner.cell")
        self.cellCollectionView?.dataSource = self
        self.cellCollectionView?.delegate = self
        
        self.contentView.addSubview(self.cellCollectionView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.ContentViewCellDidScrollClosure != nil {
            self.ContentViewCellDidScrollClosure!(scrollView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsInSectionClosure!(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeForItemAtIndexPathClosure!(collectionViewLayout, indexPath as NSIndexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let innerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "inner.cell", for: indexPath)
        for item in innerCell.contentView.subviews {
            let view = item as UIView
            view.removeFromSuperview()
        }
        var hasColor = false
        if self.cellWithColorAtIndexPathClosure != nil {
            hasColor = self.cellWithColorAtIndexPathClosure!(indexPath as NSIndexPath)
        }
        innerCell.backgroundColor = hasColor ? UIColor(red: 0xf0 / 255.0, green: 0xf0 / 255.0, blue: 0xf0 / 255.0, alpha: 1.0) : UIColor.white
        let width = self.sizeForItemAtIndexPathClosure!(nil, indexPath as NSIndexPath).width
        let height = self.sizeForItemAtIndexPathClosure!(nil, indexPath as NSIndexPath).height
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.text = self.cellForItemAtIndexPathClosure!(indexPath as NSIndexPath)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        innerCell.contentView.addSubview(label)
        innerCell.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
        innerCell.layer.borderWidth = 1.0
        
        return innerCell
    }
}
