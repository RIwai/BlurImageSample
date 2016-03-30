//
//  ViewController.swift
//  BlurImageSample
//
//  Created by Ryota Iwai on 2016/03/24.
//  Copyright © 2016年 Ryota Iwai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var originalImageView: UIImageView!

    @IBOutlet weak var continerView: UIView!
    @IBOutlet weak var originalFillImageView: UIImageView!
    @IBOutlet weak var blurFillImageView: UIImageView!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalImageView.image = UIImage(named: "hawaii")
        self.originalFillImageView.image = UIImage(named: "hawaii")
    }

    @IBAction func tapSelectImageButton(sender: AnyObject) {
        self.selectImageFromPhotoLibrary()
    }

    @IBAction func tapBlurButton(sender: AnyObject) {
        self.setBlurImage()
    }
    
    @IBAction func radiusValueChanged(sender: AnyObject) {
        self.radiusLabel.text = "radius: " + String(self.radiusSlider.value)
    }
    
    @IBAction func alphaValueChanged(sender: AnyObject) {
        self.originalFillImageView.alpha = CGFloat(self.alphaSlider.value)
    }
    
    private func setBlurImage() {
        guard let sourceImage = self.originalImageView.image else {
            return
        }
        self.blurImageView.image = BlurImage.blur(sourceImage: sourceImage,
                                                  radius: CGFloat(self.radiusSlider.value),
                                                  color: UIColor.blackColor(),
                                                  colorAlpha: 0.5,
                                                  gpu: true)
        self.blurFillImageView.image = self.blurImageView.image
    }
    
    private func selectImageFromPhotoLibrary() {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.originalImageView.image = selectedImage
            self.originalFillImageView.image = selectedImage
            self.blurImageView.image = nil
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

