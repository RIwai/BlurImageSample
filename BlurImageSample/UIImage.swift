//
//  UIImage.swift
//  BlurImageSample
//
//  Created by Ryota Iwai on 2016/03/30.
//  Copyright © 2016年 Ryota Iwai. All rights reserved.
//

import UIKit
import CoreImage

public extension UIImage {

    func trim(trimRect trimRect: CGRect) -> UIImage {
        if CGRectContainsRect(CGRect(origin: CGPoint.zero, size: self.size), trimRect) {
            if let imageRef = CGImageCreateWithImageInRect(self.CGImage, trimRect) {
                return UIImage(CGImage: imageRef)
            }
        }
        
        if trimRect.size.width == 0 || trimRect.size.height == 0 {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.drawInRect(CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else {
            return self
        }
        
        return image
    }

}
