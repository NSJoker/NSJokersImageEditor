//
//  TextView.swift
//  ImageEditor
//
//  Created by Chandrachudh on 27/02/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol TextInputViewDelegate:class {
    func didSelectTextInputView(textInputView:TextInputView)
    func showTextEditItems()
    func didEndEditing()
}

class TextInputView: PaningView, UITextViewDelegate, GrowingTextViewDelegate {

    weak var delegate: TextInputViewDelegate?
    
    let textView:GrowingTextView = GrowingTextView.init()
    let button:UIButton = UIButton.init()
//    let originalText:String = "Tap to enter your text."
    
    var fontName = "taylor-Regular"
    var textColor = UIColor.white
    var selectedSize:CGFloat = 20.0
    
    var keyBoardheight:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    convenience init(title:String,body:String,imageURL:String ){
        self.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViews() {
        self.textView.delegate = self
        self.textView.returnKeyType = .default
        self.textView.keyboardType = .default
        self.textView.autocorrectionType = .no
        self.textView.autocapitalizationType = .none
        self.textView.enablesReturnKeyAutomatically = true
        self.textView.backgroundColor = .clear
        self.textView.textAlignment = .left
        self.textView.tag = 101
        self.textView.font = UIFont.boldSystemFont(ofSize: 26)
        self.addSubview(self.textView)
        self.textView.maxHeight = CGFloat.greatestFiniteMagnitude
        self.textView.maxLength = 0
//        self.textView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0)
        self.textView.bounces = false
        self.textView.showsVerticalScrollIndicator = false
        self.textView.showsHorizontalScrollIndicator = false
        self.textView.isScrollEnabled = false

        
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(buttonTouchedDown), for: .touchUpInside)
        self.addSubview(self.button)
        
        self.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.updateTextView()
        
        self.loadPanGesture()
        self.loadRotateGesture()
        self.loadScaleGesture()
        self.isUserInteractionEnabled = true
    }
    
    func buttonTouchedDown() {
        self.superview?.bringSubview(toFront: self)
    }
    
    func buttonTapped() {
        
        self.textView.becomeFirstResponder()
        self.delegate?.didSelectTextInputView(textInputView: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
        let endFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.keyBoardheight = endFrame.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textView.frame = self.bounds
        self.button.frame = self.bounds
    }
    
    //MARK: UTEXTVIEW DELEGATE METHODS
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.button.isHidden = false
        if self.textView.text == "" {
            self.removeFromSuperview()
        }
        else {
            self.delegate?.didEndEditing()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.button.isHidden = true
        self.delegate?.showTextEditItems()
//        if self.textView.text == self.originalText {
//            self.textView.text = ""
//        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let newSize = self.textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        
        let currentCenter = self.center
        
//        print("newSize.height = \(newSize.height)")
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newSize.width, height: newSize.height)
        self.center = currentCenter
//        self.textView.contentOffset = CGPoint.zero
        
        if self.frame.maxY >= (SCREEN_HEIGHT - self.keyBoardheight) {
            let diff = self.frame.maxY - (SCREEN_HEIGHT - self.keyBoardheight)
            self.center = CGPoint(x: currentCenter.x, y: currentCenter.y-diff)
        }
    }
    
    func textViewDidChangeHeight(_ height: CGFloat) {
        
        let currentCenter = self.center
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: height)
        self.center = currentCenter
//        self.textView.contentOffset = CGPoint.zero
        
        if self.frame.maxY >= (SCREEN_HEIGHT - self.keyBoardheight) {
            let diff = self.frame.maxY - (SCREEN_HEIGHT - self.keyBoardheight)
            self.center = CGPoint(x: currentCenter.x, y: currentCenter.y-diff)
        }
    }
    
    func updateTextView() {
        self.textView.font = UIFont(name: fontName, size: self.selectedSize)
        self.textView.textColor = self.textColor
        self.textViewDidChange(self.textView)
    }
    
//    override func pangesture(gesture:UIPanGestureRecognizer) {
//    
//        let newCenterX = gesture.location(in: self.superview).x
//        var newCenterY = gesture.location(in: self.superview).y
//        self.superview?.bringSubview(toFront: self)
//        self.center = CGPoint(x: newCenterX, y: newCenterY)
//        
//        if self.textView.isFirstResponder == false {
//            print("not first responder")
//            
//            if newCenterY + self.bounds.height/2 > (self.superview?.bounds.height)! {
//                newCenterY = (self.superview?.bounds.height)! - self.bounds.height/2
//            }
//            self.originalCenter = CGPoint(x: newCenterX, y: newCenterY)
//        }
//        else {
//            print("its a first responder \(newCenterX), \(newCenterY)")
//        }
//        
//        self.endEditing(true)
//        self.panDelegate?.adjustForUserActions(view: self)
//        
//        switch gesture.state {
//        case .began:
//            self.panDelegate?.showDelete()
//            break
//        case .changed:
//            self.panDelegate?.showDelete()
//            break
//        default:
//            self.panDelegate?.hideDelete()
//            break
//        }
//        
//        if CGRect(x:SCREEN_WIDTH/2-DELETE_SIZE/2, y:SCREEN_HEIGHT - (DELETE_SIZE+10), width:DELETE_SIZE, height:DELETE_SIZE).contains(self.center) == true {
//            self.alpha = 0.2
//            self.shouldRemove = true
//            self.panDelegate?.startAnimatingDeleteView()
//        }
//        else {
//            self.alpha = 1.0
//            self.shouldRemove = false
//            self.panDelegate?.stopAnimatingDeleteView()
//        }
//        
//        if gesture.state == .ended {
//            if self.shouldRemove == true {
//                self.removeFromSuperview()
//                self.panDelegate?.viewRemoved(view: self)
//            }
//        }
//    }
}
