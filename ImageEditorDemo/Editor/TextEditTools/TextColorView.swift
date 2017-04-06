//
//  TextColorView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 06/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit
import DynamicColor

protocol TextColorViewDelegate:class {
    func showHideTextColorView()
    func colorChanged(color:UIColor)
}

class TextColorView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var delegate: TextColorViewDelegate?
    
    let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var allShades = [UIColor]()
    var selectedIndex:Int = 0
    
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
        
        var colors = [DynamicColor]()
        
        let v:UIColor = UIColor.rgb(fromHex: 0x9400D3)
        let i:UIColor = UIColor.rgb(fromHex: 0x4B0082)
        let b:UIColor = UIColor.rgb(fromHex: 0x0000FF)
        let g:UIColor = UIColor.rgb(fromHex: 0x00FF00)
        let y:UIColor = UIColor.rgb(fromHex: 0xFFFF00)
        let o:UIColor = UIColor.rgb(fromHex: 0xFF7F00)
        let r:UIColor = UIColor.rgb(fromHex: 0xFF0000)
        let w:UIColor = .white
        let bl:UIColor = .black
        
        let gradient = DynamicGradient(colors: [w,bl,v,i,b,g,y,o,r])
        
        let numbers:Int = 50
        let rgbPalette = gradient.colorPalette(amount: UInt(numbers), inColorSpace: .rgb)
        let hslPalette = gradient.colorPalette(amount: UInt(numbers), inColorSpace: .hsl)
        let hsbPalette = gradient.colorPalette(amount: UInt(numbers), inColorSpace: .hsb)
        let labPalette = gradient.colorPalette(amount: UInt(numbers), inColorSpace: .lab)
        
        for i in 0..<numbers {
            
            if colors.contains(rgbPalette[i]) == false {
                colors.append(rgbPalette[i])
            }
            if colors.contains(hslPalette[i]) == false {
                colors.append(hslPalette[i])
            }
            if colors.contains(hsbPalette[i]) == false {
                colors.append(hsbPalette[i])
            }
            if colors.contains(labPalette[i]) == false {
                colors.append(labPalette[i])
            }
        }
        
        for color in colors {
            self.allShades.append(color)
            
            if color == .white {
                self.selectedIndex = self.allShades.count-1
            }
        }
        
        let layout = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width:NAVBAR_HEIGHT, height:NAVBAR_HEIGHT)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(TextColorCell.self, forCellWithReuseIdentifier: TextColorCell.reuseIdentifier())
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
    }
    
    
    //MARK: Collectionview protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allShades.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TextColorCell = collectionView.dequeueReusableCell(withReuseIdentifier: TextColorCell.reuseIdentifier(), for: indexPath) as! TextColorCell
        
        cell.setColor(color: self.allShades[indexPath.row])
        
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
        self.delegate?.colorChanged(color: self.allShades[indexPath.row])
    }
}
