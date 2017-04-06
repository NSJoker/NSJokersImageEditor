//
//  EditorView.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

let TABBAR_HEIGHT:CGFloat = 60.0
let NAVBAR_HEIGHT:CGFloat = 60.0
let ALL_STICKER_VIEW_HEIGHT:CGFloat = SCREEN_HEIGHT*2/3
let ALL_FILTER_VIEW_HEIGHT:CGFloat = SCREEN_HEIGHT/3
let DEFAULT_STICKER_SIZE:CGFloat = 250
let DELETE_SIZE:CGFloat = 50.0
let MAX_DELETE_ANIMATING_SIZE:CGFloat = 200.0

class EditorView: EditorBaseView, AllStickersViewDelegate, PaningViewDelegate, TopTextEditDelegate, TextSizeViewDelegate, FontTypeViewDelegate, TextColorViewDelegate, AllFiltersViewDelegate {
    
    var allStickersCollection:AllStickersView?
    var currentTextView:TextInputView?
    
    let deleteAnimatingView:UIView = UIView.init()
    let deleteView:UIView = UIView.init()
    let imgDelete:UIView = UIImageView.init(image: #imageLiteral(resourceName: "delete"))
    lazy var topTextEditToolsView:TopTextEditTools = TopTextEditTools.init()
    lazy var textSizeView:TextSizeView = TextSizeView.init()
    lazy var fontTypeView:FontTypeView = FontTypeView.init()
    lazy var textColorView:TextColorView = TextColorView.init()
    lazy var filterView:AllFiltersView = AllFiltersView.init()
    
    var shouldAnimateDeleteView:Bool = false
    var didAddANewFilter:Bool = false
    
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
        
        self.baseView.backgroundColor = .clear
        self.addSubview(self.baseView)
        
        self.imageView.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFit
        self.baseView.addSubview(self.imageView)
        
        self.dismissControl.addTarget(self, action: #selector(didTapDismissControl), for: .touchUpInside)
        self.dismissControl.backgroundColor = .clear
        self.addSubview(self.dismissControl)
        self.dismissControl.isHidden = YES
        
        self.addSubview(self.navBar)
        self.addSubview(self.tabBar)
        
        self.deleteAnimatingView.backgroundColor = .red
        self.deleteAnimatingView.frame = CGRect(x: SCREEN_WIDTH/2 - DELETE_SIZE/2, y: SCREEN_HEIGHT-(DELETE_SIZE+10), width: DELETE_SIZE, height: DELETE_SIZE)
        self.deleteAnimatingView.layer.cornerRadius = DELETE_SIZE/2
        self.addSubview(self.deleteAnimatingView)
        self.deleteAnimatingView.isHidden = YES
        
        self.deleteView.backgroundColor = .red
        self.addSubview(self.deleteView)
        self.deleteView.isHidden = YES
        
        self.imgDelete.tintColor = .white
        self.deleteView.addSubview(self.imgDelete)
        self.imgDelete.clipsToBounds = YES
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let deleteImgSize:CGFloat = 30.0
        self.deleteView.frame = CGRect(x: SCREEN_WIDTH/2 - DELETE_SIZE/2, y: SCREEN_HEIGHT-(DELETE_SIZE+10), width: DELETE_SIZE, height: DELETE_SIZE)
        self.deleteView.layer.cornerRadius = DELETE_SIZE/2
        self.imgDelete.frame = CGRect(x: self.deleteView.frame.width/2 - deleteImgSize/2, y: self.deleteView.frame.height-(deleteImgSize+10), width: deleteImgSize, height: deleteImgSize)
    }
    
    func didTapDismissControl() {
        
        if self.currentTextView != nil {
            self.currentTextView?.removeFromSuperview()
            
            if (self.currentTextView?.textView.text.characters.count)! > 0 {
                self.baseView.addSubview(self.currentTextView!)
                self.currentTextView?.center = (self.currentTextView?.originalCenter)!
                print("original center = \(self.currentTextView?.originalCenter.x), \(self.currentTextView?.originalCenter.y)")
            }
        }
        self.hideAllStickersCollection()
        hideFilterView()
        self.endEditing(true)
        self.showTabBar()
    }
    
    func textEditModeActive(textView:TextInputView) {
        self.hideTabBar()
        self.currentTextView = textView
        self.dismissControl.isHidden = NO
        self.dismissControl.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.7)
        self.bringSubview(toFront: self.dismissControl)
        self.baseView.bringSubview(toFront: textView)
        textView.panDelegate = self
        
        textView.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - textView.keyBoardheight)/2)
        self.dismissControl.addSubview(textView)
        textView.textView.becomeFirstResponder()
    }
    
    func showAllStickersCollection() {
        
        self.hideTabBar()
        self.bringSubview(toFront: self.dismissControl)
        
        if self.allStickersCollection == nil {
            self.allStickersCollection = AllStickersView.init()
            self.addSubview(self.allStickersCollection!)
            self.allStickersCollection?.delegate = self
        }
        self.allStickersCollection?.isHidden = NO
        
        self.allStickersCollection?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: ALL_STICKER_VIEW_HEIGHT)
        self.allStickersCollection?.layer.cornerRadius = 8.0
        
        self.dismissControl.isHidden = NO
        self.dismissControl.backgroundColor = .clear
        self.bringSubview(toFront: self.allStickersCollection!)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.allStickersCollection?.frame = CGRect(x: 0, y: self.bounds.height - (ALL_STICKER_VIEW_HEIGHT-10), width: self.bounds.width, height: ALL_STICKER_VIEW_HEIGHT)
        }, completion: nil)
    }
    
    func hideAllStickersCollection() {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.allStickersCollection?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: ALL_STICKER_VIEW_HEIGHT)
        }) { (finished) in
            self.allStickersCollection?.isHidden = YES
            self.showTabBar()
            self.dismissControl.isHidden = YES
        }
    }
    
    func addStickerToBase(image:UIImage) {
        self.hideAllStickersCollection()
        
        let sticker = StickerView.init(frame: CGRect(x: self.baseView.frame.width/2 - DEFAULT_STICKER_SIZE/2, y: self.baseView.frame.height/2 - DEFAULT_STICKER_SIZE/2, width: DEFAULT_STICKER_SIZE, height: DEFAULT_STICKER_SIZE))
        sticker.imageView.image = image
        sticker.panDelegate = self
        self.baseView.addSubview(sticker)
    }
    
    func showFilterView(originalImage:UIImage) {
        
        if self.filterView.superview == nil {
            self.addSubview(self.filterView)
        }

        filterView.originalImage = originalImage
        self.hideTabBar()
        self.bringSubview(toFront: self.dismissControl)
        self.filterView.isHidden = NO
        self.filterView.delegate = self
        self.filterView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: ALL_FILTER_VIEW_HEIGHT)
        self.filterView.layer.cornerRadius = 8.0

        self.dismissControl.isHidden = NO
        self.dismissControl.backgroundColor = .clear
        self.bringSubview(toFront: self.filterView)

        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.filterView.frame = CGRect(x: 0, y: self.bounds.height - (ALL_FILTER_VIEW_HEIGHT-10), width: self.bounds.width, height: ALL_FILTER_VIEW_HEIGHT)
        }, completion: nil)
    }
    
    func hideFilterView() {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.filterView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: ALL_FILTER_VIEW_HEIGHT)
        }) { (finished) in
            self.filterView.isHidden = YES
            self.showTabBar()
            self.dismissControl.isHidden = YES
        }
    }
    
    func hideTabBar() {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.tabBar.alpha = 0.0
            self.navBar.alpha = 0.0
        }) { (finished) in
            self.tabBar.isHidden = YES
            self.navBar.isHidden = YES
        }
    }
    
    func showTabBar() {
        self.tabBar.alpha = 0.0
        self.tabBar.isHidden = NO
        self.navBar.alpha = 0.0
        self.navBar.isHidden = NO
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            self.tabBar.alpha = 1.0
            self.navBar.alpha = 1.0
        }) { (finished) in
            self.bringSubview(toFront: self.tabBar)
            self.bringSubview(toFront: self.navBar)
        }
        self.hideTextEditTools()
    }
    
    func showDelete() {
        self.deleteView.isHidden = NO
        self.deleteAnimatingView.isHidden = NO
        self.hideTabBar()
    }
    
    func hideDelete() {
        self.deleteView.isHidden = YES
        self.deleteAnimatingView.isHidden = YES
        self.stopAnimatingDeleteView()
        self.showTabBar()
    }
    
    func viewRemoved(view: PaningView) {
        self.hideDelete()
    }
    
    func adjustForUserActions(view: PaningView) {
        if self.currentTextView != nil {
            if self.currentTextView?.superview == self.dismissControl {
                self.currentTextView?.removeFromSuperview()
                self.baseView.addSubview(self.currentTextView!)
                self.currentTextView?.center = (self.currentTextView?.originalCenter)!
            }
        }
        self.dismissControl.isHidden = YES
        self.baseView.bringSubview(toFront: view)
    }
    
    func startAnimatingDeleteView() {

        if self.shouldAnimateDeleteView == true {
            return
        }
        print("caliing start animate")
        self.shouldAnimateDeleteView = true
        self.animateDeletView()
    }
    
    func animateDeletView() {
        if self.shouldAnimateDeleteView == true {
            self.deleteAnimatingView.alpha = 0.7
            self.deleteAnimatingView.frame = CGRect(x: SCREEN_WIDTH/2 - DELETE_SIZE/2, y: SCREEN_HEIGHT-(DELETE_SIZE+10), width: DELETE_SIZE, height: DELETE_SIZE)
            self.deleteAnimatingView.layer.cornerRadius = DELETE_SIZE/2
            
            let scale:CGFloat = 10.0
            
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.deleteAnimatingView.alpha = 0.0
                self.deleteAnimatingView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }) { (finished) in
                self.deleteAnimatingView.transform = CGAffineTransform.identity
                self.animateDeletView()
            }
        }
    }
    
    func stopAnimatingDeleteView(){
        self.shouldAnimateDeleteView = false
    }
    
    func hideTextEditTools() {
        self.topTextEditToolsView.removeFromSuperview()
        self.hidetextSizeView()
        self.hideFontTypeView()
        self.hideTextColorView()
    }
    
    func showTextEditTools() {
        
        self.topTextEditToolsView.delegate = self
        self.topTextEditToolsView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
        self.topTextEditToolsView.alignmentType = (self.currentTextView?.textView.textAlignment)!
        self.topTextEditToolsView.setUpAlignmetButton()
        self.window?.addSubview(self.topTextEditToolsView)
    }
    
    //MARK: TopTextEditDelegate Methods
    func didChangeTextAlignment(textAlignment: NSTextAlignment) {
        self.hideFontTypeView()
        self.hidetextSizeView()
        self.hideTextColorView()
        self.currentTextView?.textView.textAlignment = textAlignment
    }
    
    func showHideTextSizeView() { //TextSizeViewDelegate Method
        self.textSizeView.delegate = self
        if self.textSizeView.superview == nil {
            self.showTextSizeView()
        }
        else {
            self.hidetextSizeView()
        }
    }
    
    func showTextSizeView() {
        
        self.hideTextColorView()
        self.hideFontTypeView()
        
        self.textSizeView.frame = CGRect(x: SCREEN_WIDTH, y: NAVBAR_HEIGHT, width: NAVBAR_HEIGHT, height: SCREEN_HEIGHT - ((self.currentTextView?.keyBoardheight)! + NAVBAR_HEIGHT))
        self.window?.addSubview(self.textSizeView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.textSizeView.frame = CGRect(x: SCREEN_WIDTH-NAVBAR_HEIGHT, y: NAVBAR_HEIGHT, width: NAVBAR_HEIGHT, height: SCREEN_HEIGHT - ((self.currentTextView?.keyBoardheight)! + NAVBAR_HEIGHT))
        }) { (finished) in
            self.textSizeView.slider.setValue(Float((self.currentTextView?.selectedSize)!), animated: false)
        }
    }
    
    func hidetextSizeView() {
        if self.currentTextView == nil {
            return
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.textSizeView.frame = CGRect(x: SCREEN_WIDTH, y: NAVBAR_HEIGHT, width: NAVBAR_HEIGHT, height: SCREEN_HEIGHT - ((self.currentTextView?.keyBoardheight)! + NAVBAR_HEIGHT))
        }) { (finished) in
            self.textSizeView.removeFromSuperview()
        }
    }
    
    func fontSizeChanged(size:CGFloat) {
        self.currentTextView?.selectedSize = size
        self.currentTextView?.updateTextView()
    }
    
    func showHideFontTypeView() {
        
        self.self.fontTypeView.delegate = self
        if self.fontTypeView.superview == nil {
            self.showFontTypeView()
        }
        else {
            self.hideFontTypeView()
        }
    }
    
    func showFontTypeView() {
        
        self.hidetextSizeView()
        self.hideTextColorView()
        
        self.fontTypeView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
        self.fontTypeView.alpha = 0.0
        self.window?.addSubview(self.fontTypeView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { 
            self.fontTypeView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - ((self.currentTextView?.keyBoardheight)! + NAVBAR_HEIGHT), width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
            self.fontTypeView.alpha = 1.0
        }) { (finished) in
            
        }
        
    }
    
    func hideFontTypeView() {
        
        if self.currentTextView == nil {
            return
        }
        
        self.fontTypeView.alpha = 1.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.fontTypeView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
            self.fontTypeView.alpha = 0.0
        }) { (finished) in
            self.fontTypeView.removeFromSuperview()
        }
    }
    
    func fontChanged(fontName:String) {
        self.currentTextView?.fontName = fontName
        self.currentTextView?.updateTextView()
    }
    
    func showHideTextColorView() {
        if self.textColorView.superview == nil {
            self.showTextColorView()
        }
        else {
            self.hideTextColorView()
        }
    }
    
    func showTextColorView() {
        
        self.hideFontTypeView()
        self.hidetextSizeView()
        
        self.textColorView.delegate = self
        self.textColorView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
        self.textColorView.alpha = 0.0
        self.window?.addSubview(self.textColorView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.textColorView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - ((self.currentTextView?.keyBoardheight)! + NAVBAR_HEIGHT), width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
            self.textColorView.alpha = 1.0
        }) { (finished) in
            
        }
    }
    
    func hideTextColorView() {
        
        if self.currentTextView == nil {
            return
        }
        
        self.textColorView.alpha = 1.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.textColorView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: NAVBAR_HEIGHT)
            self.textColorView.alpha = 0.0
        }) { (finished) in
            self.textColorView.removeFromSuperview()
        }
    }
    
    func colorChanged(color:UIColor) {
        self.currentTextView?.textColor = color
        self.topTextEditToolsView.updateTextColorButtonColor(color: color)
        self.currentTextView?.updateTextView()
    }
    
    func hideAllFiltersCollection() {
        self.hideFilterView()
    }
    
    func addFilterToBase(filterType:FilterType) {
        
        guard let image = filterView.originalImage else {
            return
        }
        
        self.imageView.image = image
        self.didAddANewFilter = true
        
        switch filterType {
        case .blur:
            self.imageView.image = FilterHelper.getBlurImage(image: image)
            break
        case .invert:
            self.imageView.image = FilterHelper.getInvertImage(image: image)
            break
        case .monochrome:
            self.imageView.image = FilterHelper.getMonoChromeImage(image: image)
            break
        case .posterize:
            self.imageView.image = FilterHelper.getPosterizedImage(image: image)
            break
        case .falsecolor:
            self.imageView.image = FilterHelper.getFalseColorImage(image: image)
            break
        case .maxcomponent:
            self.imageView.image = FilterHelper.getMaxComponentImage(image: image)
            break
        case .mincomponent:
            self.imageView.image = FilterHelper.getMinComponentImage(image: image)
            break
        case .chrome:
            self.imageView.image = FilterHelper.getChromeImage(image: image)
            break
        case .fade:
            self.imageView.image = FilterHelper.getFadeImage(image: image)
            break
        case .instant:
            self.imageView.image = FilterHelper.getInstantImage(image: image)
            break
        case .mono:
            self.imageView.image = FilterHelper.getMonoImage(image: image)
            break
        case .noir:
            self.imageView.image = FilterHelper.getNoirImage(image: image)
            break
        case .process:
            self.imageView.image = FilterHelper.getProcessImage(image: image)
            break
        case .tonal:
            self.imageView.image = FilterHelper.getTonalImage(image: image)
            break
        case .transfer:
            self.imageView.image = FilterHelper.getTransferImage(image: image)
            break
        case .sepia:
            self.imageView.image = FilterHelper.getSepiaImage(image: image)
            break
        case .vignette:
            self.imageView.image = FilterHelper.getVignetteImage(image: image)
            break
        case .vignette2:
            self.imageView.image = FilterHelper.getVignette2Image(image: image)
            break
        case .colorclamp:
            self.imageView.image = FilterHelper.getColorClampImage(image: image)
            break
        case .reducedcontrast:
            self.imageView.image = FilterHelper.getReducedContrastImage(image: image)
            break
        case .reducedbrightness:
            self.imageView.image = FilterHelper.getReducedContrastImage(image: image)
            break
        case .reducedsaturation:
            self.imageView.image = FilterHelper.getReducedContrastImage(image: image)
            break
        case .gamma:
            self.imageView.image = FilterHelper.getGammaAdjustedImage(image: image)
            break
        case .lineartosrgb:
            self.imageView.image = FilterHelper.getLinearToSRGBImage(image: image)
            break
        case .vibrance:
            self.imageView.image = FilterHelper.getVibranceAdjustedImage(image: image)
            break
        default:
            didAddANewFilter = false
            self.imageView.image = image
            break
        }
        
    }
}
