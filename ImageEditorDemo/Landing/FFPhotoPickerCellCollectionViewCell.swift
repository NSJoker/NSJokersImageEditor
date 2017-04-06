//
//  FFPhotoPickerCellCollectionViewCell.swift
//  FlipFoto
//
//  Created by Chandrachudh on 14/11/16.
//  Copyright © 2016 F22Labs. All rights reserved.
//

import UIKit

class FFPhotoPickerCellCollectionViewCell: UICollectionViewCell {
    
    var assetImageView:UIImageView = UIImageView.init()
    var selectionimageView:UIImageView = UIImageView.init(image: UIImage.init(named: "select-icon"))
    let loader:UIActivityIndicatorView = UIActivityIndicatorView.init()
    var indexPath:NSIndexPath?
    
    class func reuseIdentifier() -> String {
        return "FFPhotoPickerCellCollectionViewCell"
    }
    
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
        self.assetImageView.clipsToBounds = true
        self.assetImageView.contentMode = .scaleAspectFill
        self.addSubview(self.assetImageView)
        
        self.selectionimageView.clipsToBounds = true
        self.selectionimageView.isHidden = true
        self.selectionimageView.layer.cornerRadius = 5.0
        self.addSubview(self.selectionimageView)
        
        self.backgroundColor = UIColor.clear
        self.assetImageView.layer.cornerRadius = 5.0
        
        self.loader.hidesWhenStopped = true
        self.loader.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.4)
        self.loader.clipsToBounds = true
        self.loader.layer.cornerRadius = 5.0
        self.addSubview(self.loader)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.assetImageView.frame = self.bounds
        self.selectionimageView.frame = self.bounds
        self.loader.frame = self.bounds
    }
    
    func setSelectionimageViewSelected(isHidden:Bool) {
        self.selectionimageView.isHidden = isHidden
    }
    
    func showLoader() {
        self.loader.startAnimating()
        self.bringSubview(toFront: self.loader)
    }
    
    func stopLoader() {
        self.loader.stopAnimating()
    }
}
