//
//  StickerView.swift
//  DragViewTry
//
//  Created by Chandrachudh on 16/02/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol StickerViewDelegate:class {
    func didSelectStickerView(stickerView:StickerView)
}

class StickerView: PaningView {
    
    weak var delegate: StickerViewDelegate?
    let imageView:UIImageView = UIImageView.init()
    let button:UIButton = UIButton.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    convenience init(title:String,body:String,imageURL:String ){
        self.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViews() {
        super.createViews()
        
        self.clipsToBounds = true
    
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = .clear
        self.imageView.tag = 101
        self.imageView.isUserInteractionEnabled = false
        self.addSubview(self.imageView)
        
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        self.addSubview(self.button)
        
        self.loadPanGesture()
        self.loadRotateGesture()
        self.loadScaleGesture()
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = .clear
    }
    
    func buttonTapped() {
        self.superview?.bringSubview(toFront: self)
        self.delegate?.didSelectStickerView(stickerView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = CGRect(x: self.bounds.width/2 - imageSize/2, y: self.bounds.height/2 - imageSize/2, width: imageSize, height: imageSize)
        self.button.frame = self.bounds
    }
}
