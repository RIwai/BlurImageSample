//
//  BlurImage.swift
//  BlurImageSample
//
//  Created by Ryota Iwai on 2016/03/30.
//  Copyright © 2016年 Ryota Iwai. All rights reserved.
//

import UIKit

class BlurImage {

    class func blur(sourceImage sourceImage: UIImage, radius: CGFloat, color: UIColor, colorAlpha: CGFloat, gpu: Bool) -> UIImage {
        let categoryNames = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
        if !categoryNames.contains("CIGaussianBlur") ||
            !categoryNames.contains("CIConstantColorGenerator") ||
            !categoryNames.contains("CIMultiplyBlendMode") {
            return sourceImage
        }
        guard
            let blurFilter = CIFilter(name:"CIGaussianBlur"),
            let colorFilter = CIFilter(name:"CIConstantColorGenerator"),
            let blendFilter = CIFilter(name:"CIMultiplyBlendMode"),
            let sourceCGImage = sourceImage.CGImage else {
                return sourceImage
        }
        
        let sourceCIImage = CIImage(CGImage: sourceCGImage)

        // Color
        colorFilter.setValue(CIColor(CGColor: color.colorWithAlphaComponent(colorAlpha).CGColor), forKey: kCIInputColorKey)
        guard let colorFilterOutputImage = colorFilter.outputImage else {
            return sourceImage
        }

        // Blend
        blendFilter.setValue(colorFilterOutputImage, forKey: kCIInputImageKey)
        blendFilter.setValue(sourceCIImage, forKey: kCIInputBackgroundImageKey)
        guard let blendFilterOutputImage = blendFilter.outputImage else {
            return sourceImage
        }
        
        // Blur
        blurFilter.setDefaults()
        blurFilter.setValue(blendFilterOutputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey:"inputRadius")
        
        guard let blurOutputImage = blurFilter.outputImage else {
            return sourceImage
        }
        let cgImage = CIContext(options: [kCIContextUseSoftwareRenderer: !gpu]).createCGImage(blurOutputImage, fromRect: sourceCIImage.extent)
        return UIImage(CGImage: cgImage, scale: UIScreen.mainScreen().scale, orientation: sourceImage.imageOrientation)
    }
}
