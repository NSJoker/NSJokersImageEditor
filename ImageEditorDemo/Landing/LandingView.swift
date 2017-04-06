//
//  LandingView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class LandingView: UIView {
    
    let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

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
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(self.collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
}
