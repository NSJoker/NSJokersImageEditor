//
//  EditorBaseView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class EditorBaseView: UIView {

    let baseView:UIView = UIView.init()
    let imageView:UIImageView = UIImageView.init()
    let tabBar:TabView = TabView.init()
    let navBar:NavBar = NavBar.init()
    let dismissControl = UIControl.init()
    
    func getBaseImagesCenterFrame() -> CGRect {
        var imageHeight:CGFloat = (self.imageView.image?.size.height)!
        var imageWidth:CGFloat = (self.imageView.image?.size.width)!
        
        let imageViewMaxHeight:CGFloat = SCREEN_HEIGHT
        let imageViewMaxWidth:CGFloat = SCREEN_WIDTH
        
        self.imageView.contentMode = .scaleAspectFit
        
        if imageHeight > imageWidth {//Portrait image
            if imageHeight > imageViewMaxHeight && imageWidth > imageViewMaxWidth {//If this is a large portait image then fill it to the screen
                self.imageView.contentMode = .scaleAspectFill
                return CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            }
        }
        else if imageWidth > imageHeight {//Landscape image or panorama
        }
        else {//Square image
        }
        //The control reaches here, then the image has to be fit inside the screen with its aspect ration maintained
        
        if imageHeight <= imageViewMaxHeight && imageWidth <= imageViewMaxWidth {
        }
        else {
            
            /*
             Ratio logic
             
             originalWidth/newWidth = originalHeight/newHeight
             */
            
            if imageHeight > imageViewMaxHeight {
                imageWidth = imageWidth*imageViewMaxHeight/imageHeight
                imageHeight = imageViewMaxHeight
            }
            if imageWidth > imageViewMaxWidth {
                imageHeight = imageHeight*imageViewMaxWidth/imageWidth
                imageWidth = imageViewMaxWidth
            }
        }
        
        return CGRect(x: imageViewMaxWidth/2 - imageWidth/2, y: imageViewMaxHeight/2 - imageHeight/2, width: imageWidth, height: imageHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.baseView.frame = self.getBaseImagesCenterFrame()
        self.imageView.frame = self.baseView.bounds
        self.tabBar.frame = CGRect(x: 0, y: self.bounds.height-TABBAR_HEIGHT, width: self.bounds.width, height: TABBAR_HEIGHT)
        self.navBar.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: NAVBAR_HEIGHT)
        self.dismissControl.frame = self.bounds
    }

}
