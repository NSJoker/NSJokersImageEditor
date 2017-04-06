//
//  TopTextEditTools.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 04/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol TopTextEditDelegate:class {
    func didChangeTextAlignment(textAlignment:NSTextAlignment)
    func showHideTextSizeView()
    func showHideFontTypeView()
    func showHideTextColorView()
}

class TopTextEditTools: UIView {
    
    weak var delegate: TopTextEditDelegate?
    
    var blurEffectView:UIVisualEffectView?
    
    let btnAlignment:UIButton = UIButton.init()
    var alignmentType:NSTextAlignment = .left
    
    let btnTextSize:UIButton = UIButton.init()
    let btnFontType:UIButton = UIButton.init()
    let btnTextColor:UIButton = UIButton.init()
    

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
        
        self.btnAlignment.setImage(#imageLiteral(resourceName: "Alignment-Left"), for: .normal)
        self.btnAlignment.addTarget(self, action: #selector(didTapAlignMentButton), for: .touchUpInside)
        self.btnAlignment.imageView?.tintColor = .white
        self.addSubview(self.btnAlignment)
        
        self.btnTextSize.setImage(#imageLiteral(resourceName: "TextSIze"), for: .normal)
        self.btnTextSize.addTarget(self, action: #selector(didTapTextSize), for: .touchUpInside)
        self.btnTextSize.imageView?.tintColor = .white
        self.addSubview(self.btnTextSize)
        
        self.btnFontType.setImage(#imageLiteral(resourceName: "FontType"), for: .normal)
        self.btnFontType.addTarget(self, action: #selector(didTapFontType), for: .touchUpInside)
        self.btnFontType.imageView?.tintColor = .white
        self.addSubview(self.btnFontType)
        
        self.btnTextColor.setImage(#imageLiteral(resourceName: "FontColor"), for: .normal)
        self.btnTextColor.addTarget(self, action: #selector(didTapTextColor), for: .touchUpInside)
        self.btnTextColor.imageView?.tintColor = .white
        self.addSubview(self.btnTextColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let blurView = self.blurEffectView {
            blurView.frame = self.bounds
        }
        
        let width = SCREEN_WIDTH/4
        
        self.btnAlignment.frame = CGRect(x: 0, y: 0, width: width, height: self.bounds.height)
        self.btnTextSize.frame = CGRect(x: self.bounds.width - width, y: 0, width: width, height: self.bounds.height)
        self.btnFontType.frame = CGRect(x: self.btnAlignment.frame.maxX + 5, y: 0, width: width, height: self.bounds.height)
        self.btnTextColor.frame = CGRect(x: self.bounds.width - (2*width), y: 0, width: width, height: self.bounds.height)

    }
    
    func setUpAlignmetButton() {
        switch self.alignmentType {
        case .center:
            self.btnAlignment.setImage(#imageLiteral(resourceName: "Alignmente-Center"), for: .normal)
            break
        case .right:
            self.btnAlignment.setImage(#imageLiteral(resourceName: "Alignment-Right"), for: .normal)
            break
        case .left:
            self.btnAlignment.setImage(#imageLiteral(resourceName: "Alignment-Left"), for: .normal)
            break
        default:
            break
        }

    }
    
    func didTapAlignMentButton() {
        switch self.alignmentType {
        case .left:
            self.alignmentType = .center
            break
        case .center:
            self.alignmentType = .right
            break
        case .right:
            self.alignmentType = .left
            break
        default:
            break
        }
        
        self.setUpAlignmetButton()
        self.delegate?.didChangeTextAlignment(textAlignment: self.alignmentType)
    }
    
    func didTapTextSize() {
        self.delegate?.showHideTextSizeView()
    }
    
    func didTapFontType() {
        self.delegate?.showHideFontTypeView()
    }
    
    func didTapTextColor() {
        self.delegate?.showHideTextColorView()
    }
    
    func updateTextColorButtonColor(color:UIColor) {
        self.btnTextColor.imageView?.tintColor = color
    }
}
