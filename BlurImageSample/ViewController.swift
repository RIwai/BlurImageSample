//
//  ViewController.swift
//  BlurImageSample
//
//  Created by Ryota Iwai on 2016/03/24.
//  Copyright © 2016年 Ryota Iwai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var segmentedController: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalImageView.image = UIImage(named: "hawaii")
        self.setBlurImage()
    }

    @IBAction func switchImage(sender: AnyObject) {
        self.originalImageView.hidden = self.segmentedController.selectedSegmentIndex != 0
        self.blurImageView.hidden = self.segmentedController.selectedSegmentIndex != 1
    }

    private func setBlurImage() {
        if !CIFilter.filterNamesInCategory(kCICategoryBuiltIn).contains("CIGaussianBlur") {
            return
        }
        guard
            let blurFilter = CIFilter(name:"CIGaussianBlur"),
            let sourceImage = UIImage(named: "hawaii")?.CGImage else {
                return
        }
        blurFilter.setDefaults()
        blurFilter.setValue( CIImage(CGImage: sourceImage), forKey: kCIInputImageKey)
        blurFilter.setValue(100.0, forKey:"inputRadius")

        if let outPutImage = blurFilter.outputImage {
            let cgImage = CIContext(options: nil).createCGImage(outPutImage, fromRect: outPutImage.extent)
            self.blurImageView.image = UIImage(CGImage: cgImage, scale: UIScreen.mainScreen().scale, orientation: .Up)
        }
    }
}

