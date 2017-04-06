//
//  AllFiltersView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/04/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol AllFiltersViewDelegate:class {
    func hideAllFiltersCollection()
    func addFilterToBase(filterType:FilterType)
}

class AllFiltersView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: AllFiltersViewDelegate?
    
    var blurEffectView:UIVisualEffectView?
    var originalImage:UIImage?
    
    let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UPCarouselFlowLayout.init())
    
    let filterTypesArray = [FilterType.original,.reducedbrightness, .reducedcontrast, .reducedsaturation, .colorclamp, .blur, .invert, .monochrome, .posterize, .falsecolor, .maxcomponent, .mincomponent, .chrome, .fade, .instant, .mono, .noir, .process, .tonal, .transfer, .sepia, .vignette, .gamma, .lineartosrgb, .vibrance]

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
    
    func getOriginalImageSize()->CGSize {
        
        let width = (originalImage?.size.width ?? SCREEN_HEIGHT/3)
        let height = (originalImage?.size.height ?? SCREEN_HEIGHT/3)
        
        if height > width {
            
        }
        else if width > height {
            
        }
        else {
            
        }
        return CGSize(width: 200, height: SCREEN_HEIGHT/3)
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
        
        let layout = UPCarouselFlowLayout.init()
        layout.itemSize = getOriginalImageSize()
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 1.0
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: (100/1240)*SCREEN_WIDTH)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        self.collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier())
        
        self.collectionView.bounces = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
        
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let blurView = self.blurEffectView {
            blurView.frame = self.bounds
        }
        collectionView.frame  = self.bounds
    }
    
    func swipeGestureRecognized(gesture:UISwipeGestureRecognizer) {
        
        if gesture.direction == .down {
            self.delegate?.hideAllFiltersCollection()
        }
    }
    
    //MARK:- UICollectionView Delegate and Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("filterTypesArray.count = \(filterTypesArray.count)")
        return filterTypesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier(), for: indexPath) as! FilterCell
        
        cell.populateWith(image: originalImage!, filterType: filterTypesArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        self.delegate?.addFilterToBase(filterType: filterTypesArray[indexPath.row])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleRect:CGRect = CGRect(x: self.collectionView.contentOffset.x, y: self.collectionView.contentOffset.y, width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
        
        let visiblePoint:CGPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let indexPath:IndexPath = self.collectionView.indexPathForItem(at: visiblePoint)!
        
        self.delegate?.addFilterToBase(filterType: filterTypesArray[indexPath.row])
    }
}
