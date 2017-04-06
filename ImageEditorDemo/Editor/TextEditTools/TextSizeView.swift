//
//  TextSizeView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 04/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit
protocol TextSizeViewDelegate:class {
    func showHideTextSizeView()
    func fontSizeChanged(size:CGFloat)
}

class TextSizeView: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: TextSizeViewDelegate?
    
    let slider:UISlider = UISlider.init()
    
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
        
        self.slider.isContinuous = true
        self.slider.maximumValue = 40.0
        self.slider.minimumValue = 8.0
        self.slider.minimumTrackTintColor = UIColor.white
        self.slider.maximumTrackTintColor = UIColor.gray
        self.slider.setValue(20.0, animated: true)
        self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.addSubview(self.slider)
        
        self.slider.transform = self.slider.transform.rotated(by: CGFloat(Double.pi/2))
        
        let swipeRightGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureRecognized(gesture:)))
        swipeRightGesture.delegate = self
        swipeRightGesture.direction = .right
        self.addGestureRecognizer(swipeRightGesture)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.slider.frame = CGRect(x: 10, y: 10, width: self.bounds.width-20, height: self.bounds.height-20)
    }
    
    func sliderValueChanged() {
        self.delegate?.fontSizeChanged(size:CGFloat(Int(self.slider.value)))
    }
    
    func swipeGestureRecognized(gesture:UISwipeGestureRecognizer) {
        
        if gesture.direction == .down {
            self.delegate?.showHideTextSizeView()
        }
    }
}
