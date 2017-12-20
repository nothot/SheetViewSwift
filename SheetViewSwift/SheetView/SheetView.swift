//
//  SheetView.swift
//  SheetViewSwift
//
//  Created by mengminduan on 2017/9/29.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

import UIKit

protocol SheetViewDataSource: NSObjectProtocol {
    func sheetView(sheetView: SheetView, numberOfRowsInSection section: Int) -> Int
    func sheetView(sheetView: SheetView, numberOfColsInSection section: Int) -> Int
    func sheetView(sheetView: SheetView, cellForContentItemAtIndexRow indexRow: NSIndexPath?, indexCol: NSIndexPath?) -> String
    func sheetView(sheetView: SheetView, cellForLeftColAtIndexPath indexPath: NSIndexPath?) -> String
    func sheetView(sheetView: SheetView, cellForTopRowAtIndexPath indexPath: NSIndexPath?) -> String
    func sheetView(sheetView: SheetView, cellWithColorAtIndexRow indexRow: NSIndexPath?) -> Bool

}

protocol SheetViewDelegate: NSObjectProtocol {
    func sheetView(sheetView: SheetView, heightForRowAtIndexPath indexPath: NSIndexPath?) -> CGFloat
    func sheetView(sheetView: SheetView, widthForColAtIndexPath indexPath: NSIndexPath?) -> CGFloat
    func sheetView(sheetView: SheetView, cellDidSelectedAtIndexRow indexRow: NSIndexPath?, indexCol: NSIndexPath?) -> Void

}

let leftViewCellId = "left.tableview.cell"
let topViewCellId = "top.collectionview.cell"
let contentViewCellId = "content.tableview.cell"

class SheetLeftView: UITableView {
    
}

class SheetTopView: UICollectionView {
    
}

class SheetContentView: UITableView {
    
}

class SheetView: UIView, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public weak var dataSource: SheetViewDataSource?
    public weak var delegate: SheetViewDelegate?
    public var sheetHead: String?
    public var autoResizingItemMask: Bool = true
    public var titleColWidth: CGFloat = 80;
    public var titleRowHeight: CGFloat = 60;
    
    var leftView: SheetLeftView = SheetLeftView()
    var topView: SheetTopView?
    var contentView: SheetContentView = SheetContentView()
    var sheetHeadLabel: UILabel?
    var kRowheight: CGFloat = 0
    var kColWidth: CGFloat = 0
    
    override init(frame: CGRect) {

        super.init(frame: frame)

        
        self.layer.borderColor = UIColor(red: 0xe5 / 255.0, green: 0xe5 / 255.0, blue: 0xe5 / 255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 1.0
        self.layer.borderWidth = 1.0
        
        //leftview
        
        self.leftView = SheetLeftView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.leftView.dataSource = self
        self.leftView.delegate = self
        self.leftView.showsVerticalScrollIndicator = false
        self.leftView.backgroundColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0)
        self.leftView.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
        self.leftView.layer.borderWidth = 1.0
        self.leftView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //topview
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.topView = SheetTopView(frame: CGRect.zero, collectionViewLayout: layout)
        self.topView?.dataSource = self
        self.topView?.delegate = self
        self.topView?.showsHorizontalScrollIndicator = false
        self.topView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: topViewCellId)
        self.topView?.backgroundColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0)
        self.topView?.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
        self.topView?.layer.borderWidth = 1.0
        
        //contentview
        
        self.contentView = SheetContentView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.contentView.dataSource = self
        self.contentView.delegate = self
        self.contentView.showsVerticalScrollIndicator = false
        self.contentView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.contentView.backgroundColor = self.topView?.backgroundColor
        
        self.addSubview(self.topView!)
        self.addSubview(self.leftView)
        self.addSubview(self.contentView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is SheetLeftView {
            self.contentView.contentOffset = self.leftView.contentOffset
        }
        if scrollView is SheetContentView {
            self.leftView.contentOffset = self.contentView.contentOffset
        }
        if scrollView is SheetTopView {
            for item in self.contentView.visibleCells {
                let cell = item as! ContentViewCell
                cell.cellCollectionView?.contentOffset = scrollView.contentOffset
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sheetViewWidth = self.frame.size.width
        let sheetViewHeight = self.frame.size.height
        self.leftView.frame = CGRect(x: 0, y: self.titleRowHeight, width: self.titleColWidth, height: sheetViewHeight - self.titleRowHeight)
        self.topView?.frame = CGRect(x: self.titleColWidth, y: 0, width: sheetViewWidth - self.titleColWidth, height:  self.titleRowHeight)
        self.contentView.frame = CGRect(x: self.titleColWidth, y:  self.titleRowHeight, width: sheetViewWidth - self.titleColWidth, height: sheetViewHeight -  self.titleRowHeight)
        
        if self.sheetHeadLabel != nil {
            self.sheetHeadLabel!.removeFromSuperview()
        }
        
        self.sheetHeadLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.titleColWidth, height:  self.titleRowHeight))
        self.sheetHeadLabel?.text = self.sheetHead
        self.sheetHeadLabel?.textColor = UIColor.black
        self.sheetHeadLabel?.textAlignment = NSTextAlignment.center
        self.sheetHeadLabel?.backgroundColor = UIColor(red: 0xf0 / 255.0, green: 0xf0 / 255.0, blue: 0xf0 / 255.0, alpha: 1.0)
        self.sheetHeadLabel?.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
        self.sheetHeadLabel?.layer.borderWidth = 1.0
        self.addSubview(self.sheetHeadLabel!)
        
    }
    
    
    
    
    func reloadData() {
        self.sheetHeadLabel?.frame = CGRect(x: 0, y: 0, width: self.titleColWidth, height: self.titleRowHeight)
        self.leftView.reloadData()
        self.topView?.reloadData()
        self.contentView.reloadData()
        
    }
    
    //tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource!.sheetView(sheetView: self, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = self.delegate?.sheetView(sheetView: self, heightForRowAtIndexPath: indexPath as NSIndexPath)
        if tableView is SheetLeftView {
            var leftCell = tableView.dequeueReusableCell(withIdentifier: leftViewCellId)
            if leftCell == nil {
                leftCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: leftViewCellId)
                leftCell?.selectionStyle = UITableViewCellSelectionStyle.none
            }
            for item in (leftCell?.contentView.subviews)! {
                let subView = item as UIView
                subView.removeFromSuperview()
            }
            leftCell?.backgroundColor = UIColor(red: 0xf0 / 255.0, green: 0xf0 / 255.0, blue: 0xf0 / 255.0, alpha: 1.0)
            leftCell?.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
            leftCell?.layer.borderWidth = 1.0
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.titleColWidth, height: height!))
            label.text = self.dataSource?.sheetView(sheetView: self, cellForLeftColAtIndexPath: indexPath as NSIndexPath)
            label.textColor = UIColor.black
            label.textAlignment = NSTextAlignment.center
            leftCell?.contentView.addSubview(label)
            
            return leftCell!
        }
        
        var contentCell: ContentViewCell? = tableView.dequeueReusableCell(withIdentifier: contentViewCellId) as? ContentViewCell
        if contentCell == nil {
            contentCell = ContentViewCell(style: UITableViewCellStyle.default, reuseIdentifier: contentViewCellId)
            contentCell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        contentCell?.cellForItemAtIndexPathClosure = {(indexPathInner) in
            return (self.dataSource?.sheetView(sheetView: self, cellForContentItemAtIndexRow: indexPath as NSIndexPath, indexCol: indexPathInner))!
        }
        contentCell?.numberOfItemsInSectionClosure = {(section) in
            return (self.dataSource?.sheetView(sheetView: self, numberOfColsInSection: section))!
        }
        contentCell?.sizeForItemAtIndexPathClosure = {(collectionViewLayout, indexPathInner) in
            let width = self.delegate?.sheetView(sheetView: self, widthForColAtIndexPath: indexPathInner)
            
            return CGSize(width: width!, height: height!)
        }
        contentCell?.ContentViewCellDidScrollClosure = {(scroll) in
            for item in self.contentView.visibleCells {
                let cell = item as! ContentViewCell
                cell.cellCollectionView?.contentOffset = scroll.contentOffset
            }
            self.topView?.contentOffset = scroll.contentOffset
        }
        if ((self.dataSource?.sheetView(sheetView: cellWithColorAtIndexRow: )) != nil) {
            contentCell?.cellWithColorAtIndexPathClosure = {(indexPathInner) in
                return (self.dataSource?.sheetView(sheetView: self, cellWithColorAtIndexRow: indexPath as NSIndexPath))!
            }
        }
        contentCell?.cellDidSelectedClosure = {(indexPathInner) in
            if self.delegate?.sheetView(sheetView: cellDidSelectedAtIndexRow: indexCol:) != nil {
                self.delegate?.sheetView(sheetView: self, cellDidSelectedAtIndexRow: indexPath as NSIndexPath, indexCol: indexPathInner as NSIndexPath)
            }
        }
        
        contentCell?.backgroundColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0)
        contentCell?.cellCollectionView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - self.titleColWidth, height: height!)
        contentCell?.cellCollectionView?.reloadData()
        
        return contentCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.delegate?.sheetView(sheetView: self, heightForRowAtIndexPath: indexPath as NSIndexPath))!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView is SheetLeftView {
            return
        }
        let willDisplayCell = cell as? ContentViewCell
        let didDisplayCell = tableView.visibleCells.first as? ContentViewCell
        if willDisplayCell != nil && didDisplayCell != nil && willDisplayCell?.cellCollectionView?.contentOffset.x != didDisplayCell?.cellCollectionView?.contentOffset.x {
            willDisplayCell?.cellCollectionView?.contentOffset = (didDisplayCell?.cellCollectionView?.contentOffset)!
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.sheetView(sheetView: self, numberOfColsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPathInner: IndexPath) -> CGSize {
        let width = self.delegate?.sheetView(sheetView: self, widthForColAtIndexPath: indexPathInner as NSIndexPath)
        
        return CGSize(width: width!, height: self.titleRowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: topViewCellId, for: indexPath)
        for item in topCell.contentView.subviews {
            let view = item as UIView
            view.removeFromSuperview()
        }
        topCell.backgroundColor = UIColor(red: 0xf0 / 255.0, green: 0xf0 / 255.0, blue: 0xf0 / 255.0, alpha: 1.0)
        let width = self.delegate?.sheetView(sheetView: self, widthForColAtIndexPath: indexPath as NSIndexPath)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width!, height: self.titleRowHeight))
        label.text = self.dataSource?.sheetView(sheetView: self, cellForTopRowAtIndexPath: indexPath as NSIndexPath)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        topCell.contentView.addSubview(label)
        
        topCell.layer.borderColor = UIColor(red: 0x90 / 255.0, green: 0x90 / 255.0, blue: 0x90 / 255.0, alpha: 1.0).cgColor
        topCell.layer.borderWidth = 1.0
        
        return topCell
    }
    
}
