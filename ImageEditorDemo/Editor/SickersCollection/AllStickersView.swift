//
//  AllStickersView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol AllStickersViewDelegate:class {
    func hideAllStickersCollection()
    func addStickerToBase(image:UIImage)
}

class AllStickersView: UIView, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: AllStickersViewDelegate?
    
    var blurEffectView:UIVisualEffectView?
    let handle:UIView = UIView.init()
    
    let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let allStickers = [#imageLiteral(resourceName: "coffee1"),#imageLiteral(resourceName: "coffee2"),#imageLiteral(resourceName: "coffee3"),#imageLiteral(resourceName: "coffee4"),#imageLiteral(resourceName: "coffee5"),#imageLiteral(resourceName: "coffee6"),#imageLiteral(resourceName: "coffee7"),#imageLiteral(resourceName: "coffee8"),#imageLiteral(resourceName: "coffee9"),#imageLiteral(resourceName: "cup1"),#imageLiteral(resourceName: "cup2"),#imageLiteral(resourceName: "cup3"),#imageLiteral(resourceName: "cup4"),#imageLiteral(resourceName: "cup5"),#imageLiteral(resourceName: "cup6"),#imageLiteral(resourceName: "cup7"),#imageLiteral(resourceName: "cup8"),#imageLiteral(resourceName: "cup9"),#imageLiteral(resourceName: "mask1"),#imageLiteral(resourceName: "mask2"),#imageLiteral(resourceName: "mask3"),#imageLiteral(resourceName: "mask4"),#imageLiteral(resourceName: "mask5"),#imageLiteral(resourceName: "mask6"),#imageLiteral(resourceName: "mask7"),#imageLiteral(resourceName: "mask8"),#imageLiteral(resourceName: "mask9"),#imageLiteral(resourceName: "pirates1"),#imageLiteral(resourceName: "pirates2"),#imageLiteral(resourceName: "pirates3"),#imageLiteral(resourceName: "pirates4"),#imageLiteral(resourceName: "pirates5"),#imageLiteral(resourceName: "pirates6"),#imageLiteral(resourceName: "pirates7"),#imageLiteral(resourceName: "pirates8"),#imageLiteral(resourceName: "pirates9"),#imageLiteral(resourceName: "pirates10"),#imageLiteral(resourceName: "pirates11"),#imageLiteral(resourceName: "pirates12"),#imageLiteral(resourceName: "pirates13"),#imageLiteral(resourceName: "pirates14"),#imageLiteral(resourceName: "text1"),#imageLiteral(resourceName: "text2"),#imageLiteral(resourceName: "text3"),#imageLiteral(resourceName: "text4"),#imageLiteral(resourceName: "text5"),#imageLiteral(resourceName: "text6"),#imageLiteral(resourceName: "text7"),#imageLiteral(resourceName: "text8"),#imageLiteral(resourceName: "text9"),#imageLiteral(resourceName: "text10"),#imageLiteral(resourceName: "text11"),#imageLiteral(resourceName: "text12"),#imageLiteral(resourceName: "text13"),#imageLiteral(resourceName: "text14"),#imageLiteral(resourceName: "text15")]

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
            self.blurEffectView?.alpha = 0.8
            self.blurEffectView?.clipsToBounds = YES
            self.addSubview(self.blurEffectView!)
        }
        else {
            self.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.5)
        }
        
        let layout = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width:SCREEN_WIDTH/3, height:SCREEN_WIDTH/3)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(StickerCell.self, forCellWithReuseIdentifier: StickerCell.reuseIdentifier())
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        
        self.handle.backgroundColor = .white
        self.addSubview(self.handle)
        
        let swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestureRecognized(gesture:)))
        swipeDownGesture.delegate = self
        swipeDownGesture.direction = .down
        self.addGestureRecognizer(swipeDownGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let blurView = self.blurEffectView {
            blurView.frame = self.bounds
        }
        
        let handleSize = CGSize(width: 35, height: 5)
        self.handle.frame = CGRect(x: self.bounds.width/2 - handleSize.width/2, y: 15, width: handleSize.width, height: handleSize.height)
        self.handle.layer.cornerRadius = handleSize.height/2
        
        self.collectionView.frame = CGRect(x: 0, y: self.handle.frame.maxY+20, width: self.bounds.width, height: self.bounds.height-(self.handle.frame.maxY+20+10))
    }
    
    func swipeGestureRecognized(gesture:UISwipeGestureRecognizer) {
        
        if gesture.direction == .down {
            self.delegate?.hideAllStickersCollection()
        }
    }
    
    //MARK: COLLECTIONVIEW PROTOCOLS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allStickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:StickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCell.reuseIdentifier(), for: indexPath) as! StickerCell
        cell.myImageView.image = self.allStickers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.addStickerToBase(image: self.allStickers[indexPath.row])
    }
}
