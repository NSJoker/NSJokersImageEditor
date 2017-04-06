//
//  FFCameraAlbum.swift
//  FlipFoto
//
//  Created by Chandrachudh on 14/11/16.
//  Copyright © 2016 F22Labs. All rights reserved.
//

import UIKit
import Photos

class FFCameraAlbum: NSObject {

    var albumTitle:String?
    var albumCoverImage:String?
    var photoCount:Int = 0
    var phAsset:PHAsset?
    var phFetchResult:Any?
}
