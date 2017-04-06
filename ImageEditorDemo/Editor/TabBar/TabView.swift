//
//  TabView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol TabViewDelegate:class {
    func addNewTextEntry()
    func addNewSticker()
    func addFilterView()
}

class TabView: UIView, TabButtonViewDelegate {
    
    weak var delegate: TabViewDelegate?
    
    var blurEffectView:UIVisualEffectView?
    
    let filterTab:TabButtonView = TabButtonView.init()
    let textTab:TabButtonView = TabButtonView.init()
    let stickerTab:TabButtonView = TabButtonView.init()
    
    fileprivate let numberOfItemsInTab:Int = 3

    override init(frame:CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    convenience init(){
        self.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {
        self.backgroundColor = .clear
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurEffectView?.alpha = 0.7
            self.addSubview(self.blurEffectView!)
        }
        else {
            self.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.5)
        }
        
        self.filterTab.icon.image = #imageLiteral(resourceName: "IconWand")
        self.filterTab.lblTitle.text = ""//"Coming soon"
        self.addSubview(self.filterTab)
        self.filterTab.alpha = 0.3
        self.filterTab.tag = 1
        self.filterTab.delegate = self
        
        self.textTab.icon.image = #imageLiteral(resourceName: "IconText")
        self.textTab.lblTitle.text = ""
        self.addSubview(self.textTab)
        self.textTab.tag = 2
        self.textTab.delegate = self
        
        self.stickerTab.icon.image = #imageLiteral(resourceName: "IconSticker")
        self.stickerTab.lblTitle.text = ""
        self.addSubview(self.stickerTab)
        self.stickerTab.tag = 3
        self.stickerTab.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let blurView = self.blurEffectView {
            blurView.frame = self.bounds
        }
        
        let itemWidth:CGFloat = CGFloat(self.bounds.width/CGFloat(self.numberOfItemsInTab))
        let itemHeight:CGFloat = self.bounds.height
        var x:CGFloat = 0.0
        let y:CGFloat = 0.0
        
        self.filterTab.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        x += itemWidth
        
        self.textTab.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        x += itemWidth
        
        self.stickerTab.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
    }
    
    func tabtapped(tabButtonTag:Int) {
        
        switch tabButtonTag {
        case 1:
            print("Show Filters Menu")
            self.delegate?.addFilterView()
            break
        case 2:
            self.delegate?.addNewTextEntry()
            break
        case 3:
            self.delegate?.addNewSticker()
            break
        default:
            print("Unknown Tab tapped")
            break
        }
    }
}
