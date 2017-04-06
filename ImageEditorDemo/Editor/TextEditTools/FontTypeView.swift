//
//  FontTypeView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 06/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol FontTypeViewDelegate:class {
    func showHideFontTypeView()
    func fontChanged(fontName:String)
}

class FontTypeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: FontTypeViewDelegate?
    
    let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let fontsDataSource = [UIFont.init(name: "AlexBrush-Regular", size: 26),
                           UIFont.init(name: "AngelineVintage", size: 26),
                           UIFont.init(name: "BeautifyScript", size: 30),
                           UIFont.init(name: "BLOCKSS", size: 26),
                           UIFont.init(name: "EchoStation", size: 20),
                           UIFont.init(name: "KrinkesDecorPERSONALUSE", size: 26),
                           UIFont.init(name: "KrinkesRegularPERSONALUSE", size: 30),
                           UIFont.init(name: "Libertinas-co.ffp", size: 30),
                           UIFont.init(name: "MarioNett", size: 30),
                           UIFont.init(name: "Mejorcito", size: 26),
                           UIFont.init(name: "RemachineScriptPersonalUse", size: 26),
                           UIFont.init(name: "Riesling", size: 26),
                           UIFont.init(name: "Sargento-Gorila", size: 20),
                           UIFont.init(name: "Stranger-back-in-the-Night", size: 30),
                           UIFont.init(name: "SweetheartScript-Medium", size: 26),
                           UIFont.init(name: "taylor-Regular", size: 26)]
    
    let fontsNames = ["AlexBrush-Regular", "AngelineVintage", "BeautifyScript", "BLOCKSS", "EchoStation", "KrinkesDecorPERSONALUSE", "KrinkesRegularPERSONALUSE", "Libertinas-co.ffp", "MarioNett", "Mejorcito", "RemachineScriptPersonalUse", "Riesling", "Sargento-Gorila", "Stranger-back-in-the-Night", "SweetheartScript-Medium", "taylor-Regular"]
    
    var selectedIndex:Int = -1
    
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
        self.backgroundColor = .white
        
        let layout = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width:SCREEN_WIDTH, height:NAVBAR_HEIGHT)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 5.0
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(FontTypeCell.self, forCellWithReuseIdentifier: FontTypeCell.reuseIdentifier())
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.addSubview(self.collectionView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
    }
    
    
    //MARK: Collectionview protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fontsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FontTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: FontTypeCell.reuseIdentifier(), for: indexPath) as! FontTypeCell
        
        cell.setFont(font: self.fontsDataSource[indexPath.row]!)
        
        if self.selectedIndex == indexPath.row {
            cell.setSelected()
        }
        else {
            cell.setUnSelected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        
        self.collectionView.reloadData()
        self.delegate?.fontChanged(fontName: self.fontsNames[indexPath.row])
    }
}
