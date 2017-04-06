//
//  PaningView.swift
//  ImageEditor
//
//  Created by Chandrachudh on 27/02/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

protocol PaningViewDelegate:class {
    func showDelete()
    func hideDelete()
    func adjustForUserActions(view:PaningView)
    func viewRemoved(view:PaningView)
    func startAnimatingDeleteView()
    func stopAnimatingDeleteView()
}

let imageSize:CGFloat = 150.0

class PaningView: UIView, UIGestureRecognizerDelegate{
    
    weak var panDelegate: PaningViewDelegate?
    
    var lastRotation:CGFloat = 0
    var lastScaleFactor:CGFloat = -1
    var lastTransform:CGAffineTransform?
    
    var originalCenter:CGPoint = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
    
    var shouldRemove:Bool = false
    
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
    
    func createViews() {
        
        self.clipsToBounds = true
    }
    
    func loadPanGesture() {
        let panGestureRecogniser:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(pangesture(gesture:)))
        panGestureRecogniser.delegate = self
        self.addGestureRecognizer(panGestureRecogniser)
    }
    
    func loadRotateGesture() {
        let rotateGestureRecogniser:UIRotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateGesture(gesture:)))
        rotateGestureRecogniser.delegate = self
        self.addGestureRecognizer(rotateGestureRecogniser)
    }
    
    func loadScaleGesture() {
        let pinchGestureRecogniser:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGesture(gesture:)))
        pinchGestureRecogniser.delegate = self
        self.addGestureRecognizer(pinchGestureRecogniser)
    }
    
    func pangesture(gesture:UIPanGestureRecognizer) {
//        /*SMOOTH ANIMATION CODE*/
//        let translation = gesture.translation(in: self)
//        gesture.view?.center = CGPoint(x: (gesture.view?.center.x)!+translation.x, y: (gesture.view?.center.y)! + translation.y)
//        gesture.setTranslation(CGPoint.zero, in: self)
        
        let newCenterX = gesture.location(in: self.superview).x
        let newCenterY = gesture.location(in: self.superview).y
        self.superview?.bringSubview(toFront: self)
        self.center = CGPoint(x: newCenterX, y: newCenterY)
        self.originalCenter = CGPoint(x: newCenterX, y: newCenterY)
        self.endEditing(true)
        self.panDelegate?.adjustForUserActions(view: self)
        
        switch gesture.state {
        case .began:
            self.panDelegate?.showDelete()
            break
        case .changed:
            self.panDelegate?.showDelete()
            break
        default:
            self.panDelegate?.hideDelete()
            break
        }
        
        if CGRect(x:SCREEN_WIDTH/2-DELETE_SIZE/2, y:SCREEN_HEIGHT - (DELETE_SIZE+10), width:DELETE_SIZE, height:DELETE_SIZE).contains(self.center) == true {
            self.alpha = 0.2
            self.shouldRemove = true
            self.panDelegate?.startAnimatingDeleteView()
        }
        else {
            self.alpha = 1.0
            self.shouldRemove = false
            self.panDelegate?.stopAnimatingDeleteView()
        }
        
        if gesture.state == .ended {
            if self.shouldRemove == true {
                self.removeFromSuperview()
                self.panDelegate?.viewRemoved(view: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        super.touchesBegan(touches, with: event)
        self.panDelegate?.showDelete()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.panDelegate?.hideDelete()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.panDelegate?.hideDelete()
    }
    
    func rotateGesture(gesture:UIRotationGestureRecognizer) {
        /*SMOOTH CODE*/
        gesture.view?.transform = (gesture.view?.transform.rotated(by: gesture.rotation))!
        gesture.rotation = 0
        self.endEditing(true)
        self.panDelegate?.adjustForUserActions(view: self)
        
        switch gesture.state {
        case .began:
            self.panDelegate?.showDelete()
            break
        case .changed:
            self.panDelegate?.showDelete()
            break
        default:
            self.panDelegate?.hideDelete()
            break
        }
    }
    
    func pinchGesture(gesture:UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.lastTransform = gesture.view?.transform
            break
        case .changed:
            if let newTransform = self.lastTransform {
                let scale = gesture.scale
                gesture.view?.transform = newTransform.scaledBy(x: scale, y: scale)
            }
            break
        default:
            break
        }
        self.endEditing(true)
        self.panDelegate?.adjustForUserActions(view: self)
        
        switch gesture.state {
        case .began:
            self.panDelegate?.showDelete()
            break
        case .changed:
            self.panDelegate?.showDelete()
            break
        default:
            self.panDelegate?.hideDelete()
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
