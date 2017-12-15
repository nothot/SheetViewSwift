//
//  ViewController.swift
//  SheetViewSwift
//
//  Created by mengminduan on 2017/9/29.
//  Copyright © 2017年 mengminduan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SheetViewDelegate, SheetViewDataSource {
    func sheetView(sheetView: SheetView, numberOfRowsInSection section: Int) -> Int {
        return 48
    }
    
    func sheetView(sheetView: SheetView, numberOfColsInSection section: Int) -> Int {
        return 40
    }
    
    func sheetView(sheetView: SheetView, cellForContentItemAtIndexRow indexRow: NSIndexPath?, indexCol: NSIndexPath?) -> String {
        let str1 = String(describing: indexRow!.row)
        let str2 = String(indexCol!.row)
        
        return "data(\(str1),\(str2))"

    }
    
    func sheetView(sheetView: SheetView, cellForLeftColAtIndexPath indexPath: NSIndexPath?) -> String {
        let str = String(describing: indexPath!.row)
        return "row(\(str))"

    }
    
    func sheetView(sheetView: SheetView, cellForTopRowAtIndexPath indexPath: NSIndexPath?) -> String {
        let str = String(describing: indexPath!.row)
        return "col(\(str))"
        
    }
    
    func sheetView(sheetView: SheetView, cellWithColorAtIndexRow indexRow: NSIndexPath?) -> Bool {
        return ((indexRow?.row)! % 2 == 1) ? true : false
    }
    
    func sheetView(sheetView: SheetView, heightForRowAtIndexPath indexPath: NSIndexPath?) -> CGFloat {
        return 60
    }
    
    func sheetView(sheetView: SheetView, widthForColAtIndexPath indexPath: NSIndexPath?) -> CGFloat {
        return CGFloat(80 + 10 * (indexPath?.row)!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let sheetView = SheetView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 20))
        sheetView.dataSource = self
        sheetView.delegate = self
        sheetView.sheetHead = "sheet"
        self.view.addSubview(sheetView)
        
    }


}

