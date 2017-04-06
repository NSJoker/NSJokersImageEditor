//
//  FinalViewController.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

    var myView:FinalView{return view as! FinalView}
    
    override func loadView() {
        super.loadView()
        view = FinalView.init()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.perform(#selector(showAlert), with: nil, afterDelay: 2.0)
        
    }
    
    func showAlert() {
        let alert = UIAlertController.init(title: "Save Image", message: "Would you like to save the image to your gallery?", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction.init(title: "Save", style: .default) { (action) in
            UIImageWriteToSavedPhotosAlbum(self.myView.imageView.image!, nil, nil, nil);
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
