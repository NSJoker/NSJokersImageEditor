//
//  FinalView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class FinalView: UIView {
    
    let imageView:UIImageView = UIImageView.init()
    
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
        self.backgroundColor = .black
        
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
    
}
