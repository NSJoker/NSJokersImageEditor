//
//  TabButtonView.swift
//  ImageEditor
//
//  Created by Chandrachudh on 22/02/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol TabButtonViewDelegate:class {
    func tabtapped(tabButtonTag:Int)
}

class TabButtonView: UIView {

    weak var delegate: TabButtonViewDelegate?
    
    let icon:UIImageView = UIImageView.init()
    let lblTitle:UILabel = UILabel.init()
    let button:UIButton = UIButton.init()
    
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
        
        self.icon.backgroundColor = .clear
        self.icon.contentMode = .scaleAspectFit
        self.icon.tintColor = UIColor.white
        self.addSubview(self.icon)
        
        self.lblTitle.text = ""
        self.lblTitle.textColor = .white
        self.lblTitle.textAlignment = .center
        self.lblTitle.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.lblTitle)
        
        self.button.backgroundColor = .clear
        self.button.addTarget(self, action: #selector(didClickTabButton), for: .touchUpInside)
        self.addSubview(self.button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGFloat = 40.0
        
        self.lblTitle.sizeToFit()
        
        var labelHeight:CGFloat = self.lblTitle.bounds.height
        
        if labelHeight > 0 {
            labelHeight = 20.0
        }
        
        self.lblTitle.frame = CGRect(x: 0, y: self.bounds.height-labelHeight, width: self.bounds.width, height: labelHeight)
        self.icon.frame = CGRect(x: self.bounds.width/2 - imageSize/2, y: (self.bounds.height - labelHeight)/2 - imageSize/2, width: imageSize, height: imageSize)
        
        self.button.frame = self.bounds
    }
    
    func didClickTabButton() {
        self.delegate?.tabtapped(tabButtonTag: self.tag)
    }
}
