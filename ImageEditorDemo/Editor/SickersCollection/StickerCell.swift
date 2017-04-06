//
//  StickerCell.swift
//  ImageEditor
//
//  Created by Chandrachudh on 27/02/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class StickerCell: UICollectionViewCell {
    
    class func reuseIdentifier()->String {
        return "StickerCell"
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
        
        self.myImageView.contentMode = .scaleAspectFit
        self.myImageView.backgroundColor = .clear
        self.addSubview(self.myImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.myImageView.frame = CGRect(x: 5, y: 5, width: self.bounds.width-10, height: self.bounds.height-10)
    }
}
