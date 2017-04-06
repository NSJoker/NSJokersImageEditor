//
//  FilterCell.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/04/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit
import Foundation

class FilterCell: UICollectionViewCell {
    class func reuseIdentifier()->String {
        return "FilterCell"
    }
    
    let myImageView:UIImageView = UIImageView.init()
    let lblFitlerType:UILabel = UILabel.init()
    
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
                
        self.myImageView.contentMode = .scaleAspectFit
        self.myImageView.backgroundColor = .clear
        self.addSubview(self.myImageView)
        
        lblFitlerType.text = ""
        lblFitlerType.textColor = .white
        lblFitlerType.textAlignment = .center
        lblFitlerType.font = UIFont.systemFont(ofSize: 12)
        lblFitlerType.numberOfLines = 0
        self.addSubview(lblFitlerType)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.myImageView.frame = CGRect(x: 5, y: 10, width: self.bounds.width-10, height: self.bounds.height-50)
        lblFitlerType.frame = CGRect(x: 5, y: myImageView.frame.maxY, width: self.bounds.width-10, height: self.bounds.height - myImageView.frame.maxY - 5)
    }
    
    func populateWith(image:UIImage, filterType:FilterType) {
        
        switch filterType {
        case .blur:
            self.myImageView.image = FilterHelper.getBlurImage(image: image)
            lblFitlerType.text = "Blur (5px brush)"
            lblFitlerType.textColor = UIColor.red
            break
        case .invert:
            self.myImageView.image = FilterHelper.getInvertImage(image: image)
            lblFitlerType.text = "Invert"
            lblFitlerType.textColor = UIColor.white
            break
        case .monochrome:
            self.myImageView.image = FilterHelper.getMonoChromeImage(image: image)
            lblFitlerType.text = "Monochrome"//"Monochrome\nCan have any color,\nHere Blue"
            lblFitlerType.textColor = UIColor.red
            break
        case .posterize:
            self.myImageView.image = FilterHelper.getPosterizedImage(image: image)
            lblFitlerType.text = "Posterized"
            lblFitlerType.textColor = UIColor.red
            break
        case .falsecolor:
            self.myImageView.image = FilterHelper.getFalseColorImage(image: image)
            lblFitlerType.text = "False Color"//"False Color\nFalse color is often used to process astronomical and other scientific data, such as ultraviolet and x-ray images."
            lblFitlerType.textColor = UIColor.red
            break
        case .maxcomponent:
            self.myImageView.image = FilterHelper.getMaxComponentImage(image: image)
            lblFitlerType.text = "Max Component Highighted"
            lblFitlerType.textColor = UIColor.white
            break
        case .mincomponent:
            self.myImageView.image = FilterHelper.getMinComponentImage(image: image)
            lblFitlerType.text = "Min Component Highighted"
            lblFitlerType.textColor = UIColor.white
            break
        case .chrome:
            self.myImageView.image = FilterHelper.getChromeImage(image: image)
            lblFitlerType.text = "Chrome"
            lblFitlerType.textColor = UIColor.white
            break
        case .fade:
            self.myImageView.image = FilterHelper.getFadeImage(image: image)
            lblFitlerType.text = "Fade"
            lblFitlerType.textColor = UIColor.white
            break
        case .instant:
            self.myImageView.image = FilterHelper.getInstantImage(image: image)
            lblFitlerType.text = "Instant"
            lblFitlerType.textColor = UIColor.white
            break
        case .mono:
            self.myImageView.image = FilterHelper.getMonoImage(image: image)
            lblFitlerType.text = "Mono"
            lblFitlerType.textColor = UIColor.white
            break
        case .noir:
            self.myImageView.image = FilterHelper.getNoirImage(image: image)
            lblFitlerType.text = "Noir"
            lblFitlerType.textColor = UIColor.white
            break
        case .process:
            self.myImageView.image = FilterHelper.getProcessImage(image: image)
            lblFitlerType.text = "Process"
            lblFitlerType.textColor = UIColor.white
            break
        case .tonal:
            self.myImageView.image = FilterHelper.getTonalImage(image: image)
            lblFitlerType.text = "Tonal"
            lblFitlerType.textColor = UIColor.white
            break
        case .transfer:
            self.myImageView.image = FilterHelper.getTransferImage(image: image)
            lblFitlerType.text = "Transfer"
            lblFitlerType.textColor = UIColor.white
            break
        case .sepia:
            self.myImageView.image = FilterHelper.getSepiaImage(image: image)
            lblFitlerType.text = "Sepia"
            lblFitlerType.textColor = UIColor.white
            break
        case .vignette:
            self.myImageView.image = FilterHelper.getVignetteImage(image: image)
            lblFitlerType.text = "Vignette"
            lblFitlerType.textColor = UIColor.white
            break
        case .vignette2:
            self.myImageView.image = FilterHelper.getVignette2Image(image: image)
            lblFitlerType.text = "Vignette2"
            lblFitlerType.textColor = UIColor.white
            break
        case .colorclamp:
            self.myImageView.image = FilterHelper.getColorClampImage(image: image)
            lblFitlerType.text = "Color Clamp"
            lblFitlerType.textColor = UIColor.red
            break
        case .reducedcontrast:
            self.myImageView.image = FilterHelper.getReducedContrastImage(image: image)
            lblFitlerType.text = "Reduced Contrast"
            lblFitlerType.textColor = UIColor.red
            break
        case .reducedbrightness:
            self.myImageView.image = FilterHelper.getReducedContrastImage(image: image)
            lblFitlerType.text = "Reduced Brightness"
            lblFitlerType.textColor = UIColor.red
            break
        case .reducedsaturation:
            self.myImageView.image = FilterHelper.getReducedContrastImage(image: image)
            lblFitlerType.text = "Reduced Saturation"
            lblFitlerType.textColor = UIColor.red
            break
        case .gamma:
            self.myImageView.image = FilterHelper.getGammaAdjustedImage(image: image)
            lblFitlerType.text = "Midtone Brightness Adjusted to Max"
            lblFitlerType.textColor = UIColor.red
            break
        case .lineartosrgb:
            self.myImageView.image = FilterHelper.getLinearToSRGBImage(image: image)
            lblFitlerType.text = "Natural"
            lblFitlerType.textColor = UIColor.white
            break
        case .vibrance:
            self.myImageView.image = FilterHelper.getVibranceAdjustedImage(image: image)
            lblFitlerType.text = "Vibrance"//"Vibrance\nAdjusts the saturation of an image while keeping pleasing skin tones."
            lblFitlerType.textColor = UIColor.red
            break
        default:
            self.myImageView.image = image
            lblFitlerType.text = "Original"
            break
        }
        
        self.myImageView.contentMode = .scaleAspectFit
    }
    
    
}
