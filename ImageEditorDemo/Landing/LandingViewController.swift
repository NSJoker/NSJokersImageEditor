//
//  LandingViewController.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 01/03/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class LandingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myView:LandingView{return view as! LandingView}
    
    var albumArray = [FFCameraAlbum]()
    var completeImagelist = [FFImageAsset]()
    let manager:PHImageManager = PHImageManager.default()
    let options:PHImageRequestOptions = PHImageRequestOptions.init()
    let imageDefaultSize:CGSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)//PHImageManagerMaximumSize//
    var cameraRollItemCount = 0
    var isFinishedLoadingImages:Bool = false
    var selectedImage:FFImageAsset?
    var selectedIndex:IndexPath?
    
    override func loadView() {
        super.loadView()
        view = LandingView.init()
        self.myView.collectionView.delegate = self
        self.myView.collectionView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.options.deliveryMode = .highQualityFormat
        self.options.isSynchronous = true
        self.options.resizeMode = .none
        self.options.version = .current
        self.options.isNetworkAccessAllowed = true
        
        self.myView.collectionView.register(FFPhotoPickerCellCollectionViewCell.self, forCellWithReuseIdentifier: FFPhotoPickerCellCollectionViewCell.reuseIdentifier())
        
        let layout = UICollectionViewFlowLayout.init()
        let size:CGFloat = (SCREEN_WIDTH-30)/3
        layout.itemSize = CGSize(width: size, height: size)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        self.myView.collectionView.setCollectionViewLayout(layout, animated: true)
        
        self.askPermissionForGalleryAccess()
    }
    
    func askPermissionForGalleryAccess() {
        
        switch PHPhotoLibrary.authorizationStatus() {
        case PHAuthorizationStatus.notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                switch status {
                case PHAuthorizationStatus.authorized:
                    self.getImagesFromGallery()
                    break
                case PHAuthorizationStatus.restricted:
                    break
                case PHAuthorizationStatus.denied:
                    break
                default:
                    break
                }
            })
            break
        case PHAuthorizationStatus.denied:
            self.askUserToChangePermissionFromSettings()
            break
        case PHAuthorizationStatus.restricted:
            self.askUserToChangePermissionFromSettings()
            break
        default:
            self.getImagesFromGallery()
            break
        }
    }
    
    func getImagesFromGallery() {
        
        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        
        let fetchOptions:PHFetchOptions = PHFetchOptions.init()
        fetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let predicateString = "mediaType = 1"
        fetchOptions.predicate = NSPredicate(format: predicateString)
        
        let tempImageArray:NSMutableOrderedSet = NSMutableOrderedSet.init()
        
        var cameraRollIndex = 0
        
        DispatchQueue.global(qos: .background).async {
            
            var hasGotAllPhotos = false
            
            for i in 0..<smartAlbums.count {
                
                let assetCollection:PHAssetCollection = smartAlbums[i]
                
                let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
                
                
                if (assetsFetchResult.count) > 0 {
                    if assetCollection.localizedTitle != "Camera Roll" &&  assetCollection.localizedTitle != "All Photos"{
                        let asset:PHAsset = assetsFetchResult[0]
                        
                        let album:FFCameraAlbum = FFCameraAlbum.init()
                        album.albumTitle = assetCollection.localizedTitle
                        album.photoCount = (assetsFetchResult.count)
                        album.albumCoverImage = asset.localIdentifier
                        album.phAsset = asset
                        album.phFetchResult = assetsFetchResult
                        self.albumArray.append(album)
                    }
                    else {
                        cameraRollIndex = i
                    }
                }
            }
            
            let assetCollection:PHAssetCollection = smartAlbums[cameraRollIndex]
            let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            
            self.cameraRollItemCount = assetsFetchResult.count
            
            self.isFinishedLoadingImages = true
            if (assetCollection.localizedTitle == "Camera Roll" || assetCollection.localizedTitle == "All Photos") && hasGotAllPhotos == false {
                
                hasGotAllPhotos = true
                
                for i in 0..<self.cameraRollItemCount {
                    
                    let imageAsset:FFImageAsset = FFImageAsset()
                    imageAsset.asset = assetsFetchResult[i]
                    
                    tempImageArray.add(imageAsset)
                    
                }
                
                DispatchQueue.main.async {
                    self.completeImagelist = tempImageArray.array as! [FFImageAsset]
                    self.myView.collectionView.reloadData()
                }
            }
        }
    }
    
    func askUserToChangePermissionFromSettings() {
        
        let alert:UIAlertController = UIAlertController.init(title: "Access Denied", message: "Please allow FlipFoto acess to your photos", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction:UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let enableAction:UIAlertAction = UIAlertAction.init(title: "Enable Access", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction!) -> Void in
            
            if UIApplicationOpenSettingsURLString.characters.count > 0 {
                let settings:NSURL = NSURL.init(string: UIApplicationOpenSettingsURLString)!
                //                UIApplication.shared.openURL(settings as URL)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open((settings as URL), options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settings as URL)
                }
            }
            
        })
        alert.addAction(enableAction)
        
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: COLLECTIONVIEW PROTOCOL FUNCTION IMPLEMENTATIONS
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.cameraRollItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:FFPhotoPickerCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: FFPhotoPickerCellCollectionViewCell.reuseIdentifier(), for: indexPath) as! FFPhotoPickerCellCollectionViewCell
        
        cell.showLoader()
        cell.indexPath = indexPath as NSIndexPath
        cell.assetImageView.image = nil
        
        let currentIndexPath:NSIndexPath = indexPath as NSIndexPath
        
        let list:[FFImageAsset] = self.completeImagelist.reversed()
        
        let myAsset:PHAsset = (list[indexPath.row] as FFImageAsset).asset!
        
        let cropSize = min(myAsset.pixelWidth, myAsset.pixelHeight)
        let square:CGRect = CGRect(x:0, y:0, width:cropSize, height:cropSize)
        let cropRect:CGRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(myAsset.pixelWidth), y: 1.0/CGFloat(myAsset.pixelHeight)));
        
        self.options.normalizedCropRect = cropRect
        
        DispatchQueue.global(qos: .background).async {
            self.manager.requestImage(for: myAsset, targetSize: self.imageDefaultSize, contentMode: PHImageContentMode.default, options: self.options, resultHandler:{ (image:UIImage?, info: [AnyHashable : Any]?) -> Void in
                DispatchQueue.main.async {
                    if currentIndexPath.row == cell.indexPath?.row {
                        cell.assetImageView.image = image
                        cell.stopLoader()
                        if image == nil {
                            print("image is nil")
                        }
                    }
                }
            })
        }
        cell.setSelectionimageViewSelected(isHidden: !(list[indexPath.row] as FFImageAsset).isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell:FFPhotoPickerCellCollectionViewCell = collectionView.cellForItem(at: indexPath) as! FFPhotoPickerCellCollectionViewCell
        
        if cell.assetImageView.image == nil {
            return
        }
        
        let tappedImage = self.completeImagelist.reversed()[indexPath.row]
        
        if tappedImage.isSelected == true {
            tappedImage.isSelected = false
            self.selectedImage = nil
        }
        else {
            for i in 0..<self.completeImagelist.count {
                let imageObj = self.completeImagelist[i]
                imageObj.isSelected = false
            }
            tappedImage.isSelected = true
            self.selectedImage = tappedImage
        }
        
        self.selectedIndex = indexPath
        
        
        if let selectedImageObj = self.selectedImage {
            
            let myAsset:PHAsset = selectedImageObj.asset!
            
            self.manager.requestImage(for: myAsset, targetSize:PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: self.options, resultHandler:{ (image:UIImage?, info: [AnyHashable : Any]?) -> Void in
                
                let editorController = EditorViewController.init()
                editorController.selectedImage = image
                self.navigationController?.pushViewController(editorController, animated: true)
            })
        }
        self.perform(#selector(reloadCollectionView), with: nil, afterDelay: 1.0)
    }
    
    func reloadCollectionView() {
        self.myView.collectionView.reloadData()
    }
}
