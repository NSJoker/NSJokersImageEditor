//
//  TextColorCell.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 06/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class TextColorCell: UICollectionViewCell {
    
    let baseView:UIView = UIView.init()
    let imgSelection:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "select-icon"))
    
    class func reuseIdentifier()->String {
        return "TextColorCell"
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
        
        self.baseView.backgroundColor = .white
        self.baseView.clipsToBounds = true
        self.addSubview(self.baseView)
        
        self.imgSelection.backgroundColor = .clear
        self.imgSelection.clipsToBounds = true
        self.imgSelection.isHidden = true
        self.baseView.addSubview(self.imgSelection)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.baseView.frame = CGRect(x: 2, y: 2, width: self.bounds.width - 4, height: self.bounds.height-4)
        self.imgSelection.frame = self.baseView.bounds
        
        self.baseView.layer.cornerRadius = 4.0
        self.imgSelection.layer.cornerRadius = 4.0
    }
    
    func setColor(color:UIColor) {
        self.baseView.backgroundColor = color
    }
    
    func setSelected() {
        self.imgSelection.isHidden = false
    }
    
    func setUnSelected() {
        self.imgSelection.isHidden = true
    }
}
