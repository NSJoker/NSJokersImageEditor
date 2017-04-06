//
//  FilterHelper.swift
//  ImageEditorDemo
//
//  Created by Chandrachudh on 03/04/17.
//  Copyright © 2017 F22Labs. All rights reserved.
//

import UIKit

enum FilterType {
    case original,reducedbrightness, reducedcontrast, reducedsaturation ,colorclamp,blur,invert,monochrome,posterize,falsecolor,maxcomponent,mincomponent,chrome,fade,instant,mono,noir,process,tonal,transfer,sepia,vignette,vignette2,gamma,lineartosrgb,vibrance
}

class FilterHelper: NSObject {
    
    class func getVibranceAdjustedImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputAmount": NSNumber.init(value: 3.0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIVibrance", withInputParameters:parameters)
        
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getLinearToSRGBImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CILinearToSRGBToneCurve")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getGammaAdjustedImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputPower": NSNumber.init(value: 3.0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIGammaAdjust", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getReducedSaturationImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputSaturation": NSNumber.init(value: 1.5),
            "inputBrightness": NSNumber.init(value: 1.0),
            "inputContrast": NSNumber.init(value: 1.0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorControls", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getReducedBrightnessImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputSaturation": NSNumber.init(value: 1.0),
            "inputBrightness": NSNumber.init(value: 0.75),
            "inputContrast": NSNumber.init(value: 1.0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorControls", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getReducedContrastImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputSaturation": NSNumber.init(value: 1.0),
            "inputBrightness": NSNumber.init(value: 1.0),
            "inputContrast": NSNumber.init(value: 3.5),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorControls", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getColorClampImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputMaxComponents": CIVector.init(x: 0.5, y: 0.5, z: 0.5, w: 0.5),
            "inputMinComponents": CIVector.init(x: 0, y: 0, z: 0, w: 0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorClamp", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getBlurImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIBoxBlur")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(5.0, forKey: kCIInputRadiusKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getInvertImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getMonoChromeImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputColor": CIColor.init(color: .blue),
            "inputIntensity": NSNumber.init(value: 0.5),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorMonochrome", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getPosterizedImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputLevels": NSNumber.init(value: 6.0),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIColorPosterize", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getFalseColorImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let parameters : Dictionary<String, AnyObject> = [
            "inputColor0": CIColor.init(color: UIColor.rgba(fromHex: 0x2980b9, alpha: 0.2)),
            "inputColor1": CIColor.init(color: UIColor.rgba(fromHex: 0xe74c3c, alpha: 0.5)),
            kCIInputImageKey: coreImage
        ]
        
        let filter = CIFilter(name:"CIFalseColor", withInputParameters:parameters)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getMaxComponentImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIMaximumComponent")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getMinComponentImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIMinimumComponent")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getChromeImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getFadeImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getInstantImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectInstant")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getMonoImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getNoirImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getProcessImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getTonalImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectTonal")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getTransferImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getSepiaImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getVignetteImage(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIVignette")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }
    
    class func getVignette2Image(image:UIImage) -> UIImage {
        
        guard let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return image
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIVignetteEffect")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let cgImageRef:CGImage = CIContext.init(options: nil).createCGImage(output, from: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))!
            let filteredImage = UIImage(cgImage: cgImageRef)
            return filteredImage
        }
            
        else {
            return image
        }
    }

}
