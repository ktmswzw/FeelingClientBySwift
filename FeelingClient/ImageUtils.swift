//
//  ImageUtils.swift
//  feeling
//
//  Created by vincent on 15/12/29.
//  Copyright © 2015年 xecoder. All rights reserved.
//

import Foundation
import Photos
import UIKit


func getAssetThumbnail(asset: PHAsset) -> UIImage {
    let manager = PHImageManager.defaultManager()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.synchronous = true
    manager.requestImageForAsset(asset, targetSize: CGSize(width: 50.0, height: 50.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
        thumbnail = result!
    })
    return thumbnail
}

extension UIViewController {

/**
 * Called when 'return' key pressed. return NO to ignore.
 */
func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}


/**
 * Called when the user click on the view (outside the UITextField).
 */
override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
}
//    
//    
//    override func viewDidLoad() {
//        self.view.layer.contents = UIImage(named: "Backgroup.png")?.CGImage
//        // Do any additional setup after loading the view.
//    }

}