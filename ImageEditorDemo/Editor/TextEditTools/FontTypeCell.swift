//
//  FontTypeCell.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 06/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class FontTypeCell: UICollectionViewCell {
    
    let lblFont:UILabel = UILabel.init()
    
    class func reuseIdentifier()->String {
        return "FontTypeCell"
    }
    
    let myImageView:UIImageView = UIImageView.init()
    
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
        
        self.lblFont.backgroundColor = .clear
        self.lblFont.text = "Aloha Mora!"
        self.lblFont.textAlignment = .center
        self.lblFont.textColor = .black
        self.addSubview(self.lblFont)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblFont.frame = self.bounds
    }
    
    func setFont(font:UIFont) {
        self.lblFont.font = font
    }
    
    func setSelected() {
        self.lblFont.textColor = .blue
    }
    
    func setUnSelected() {
        self.lblFont.textColor = .black
    }
    
}
