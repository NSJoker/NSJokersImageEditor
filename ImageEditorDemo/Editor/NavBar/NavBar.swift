//
//  NavBar.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol NavBarDelegate:class {
    func goBackToSelectionScreen()
    func saveTheImage()
}

class NavBar: UIView {
    
    weak var delegate: NavBarDelegate?
    
    var blurEffectView:UIVisualEffectView?
    
    let imgBack:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "back"))
    let btnBack:UIButton = UIButton.init()
    
    let imgSave:UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "save"))
    let btnSave:UIButton = UIButton.init()

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
        
        self.imgBack.tintColor = .white
        self.addSubview(self.imgBack)
        
        self.btnBack.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.addSubview(self.btnBack)
        
        self.imgSave.tintColor = .white
        self.addSubview(self.imgSave)
        
        self.btnSave.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        self.addSubview(self.btnSave)
    }
    
    func didTapBackButton() {
        self.delegate?.goBackToSelectionScreen()
    }
    
    func didTapSaveButton() {
        self.delegate?.saveTheImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let blurView = self.blurEffectView {
            blurView.frame = self.bounds
        }
        
        self.imgBack.frame = CGRect(x: 15, y: self.bounds.height/2 - 25/2, width: 25, height: 25)
        self.btnBack.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        
        self.imgSave.frame = CGRect(x: self.bounds.width - (15+30), y: self.bounds.height/2 - 30/2, width: 30, height: 30)
        self.btnSave.frame = CGRect(x: self.bounds.width - self.bounds.height, y: 0, width: self.bounds.height, height: self.bounds.height)
    }
}
