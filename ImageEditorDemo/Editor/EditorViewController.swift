//
//  EditorViewController.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, TabViewDelegate, TextInputViewDelegate, NavBarDelegate {

    fileprivate var myView:EditorView{return view as! EditorView}
    
    var selectedImage:UIImage? = nil
    var originalImage:UIImage? = nil
    
    override func loadView() {
        super.loadView()
        view = EditorView.init()
        self.myView.tabBar.delegate = self
        self.myView.navBar.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let selectedImage = self.selectedImage {
            self.myView.imageView.image = selectedImage
            originalImage = selectedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:TabViewDelegate Methods
    func addNewTextEntry() {
        
        let textView:TextInputView = TextInputView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        textView.center = self.myView.center
        self.myView.baseView.addSubview(textView)
        textView.delegate = self
        textView.originalCenter = self.myView.imageView.center
        
        self.myView.textEditModeActive(textView: textView)
    }
    
    func addNewSticker() {
        self.myView.showAllStickersCollection()
    }
    
    func addFilterView() {
        self.myView.showFilterView(originalImage: originalImage!)
    }
    
    func didSelectTextInputView(textInputView: TextInputView) {
        
        self.myView.textEditModeActive(textView: textInputView)
        
//        self.myView.hideTabBar()
//        self.myView.currentTextView = textInputView
//        self.myView.dismissControl.isHidden = YES
//        self.myView.baseView.bringSubview(toFront: textInputView)
//        textInputView.panDelegate = self.myView
//        
//        textInputView.center = CGPoint(x: SCREEN_WIDTH/2, y: (SCREEN_HEIGHT - textInputView.keyBoardheight)/2)
    }
    
    func didEndEditing() {
        self.myView.didTapDismissControl()
    }
    
    //MARK: NavBarDelegate Methods
    func goBackToSelectionScreen() {
        
        if self.myView.baseView.subviews.count > 1 {
            let alert = UIAlertController.init(title: "Warning", message: "The changes you made will be lost.", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            let ignoreAction = UIAlertAction.init(title: "Ignore Changes", style: .destructive, handler: { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(cancelAction)
            alert.addAction(ignoreAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveTheImage() {
        if self.myView.baseView.subviews.count <= 1 && self.myView.didAddANewFilter == false {
            let alert = UIAlertController.init(title: "Error", message: "no changes were made to the image. Please make some changes and try again.", preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let newImage = self.getSnapShots()
            
            let finalController = FinalViewController.init()
            finalController.myView.imageView.image = newImage
            self.navigationController?.pushViewController(finalController, animated: true)

        }
    }
    
    func getSnapShots() -> UIImage {
        
        let size = self.myView.baseView.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, view.isOpaque, 0.0)

        self.myView.baseView.drawHierarchy(in: self.myView.baseView.bounds, afterScreenUpdates: false)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
        
    }
    
    func showTextEditItems() {
        self.myView.showTextEditTools()
    }
}
