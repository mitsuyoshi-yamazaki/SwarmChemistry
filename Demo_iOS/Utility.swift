//
//  Utility.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/14.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import UIKit

extension UIViewController {
  @IBAction func dismiss(sender: AnyObject!) {
    dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func takeScreenshot(_ rect: CGRect? = nil) -> UIImage? {
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    drawHierarchy(in: bounds, afterScreenUpdates: true)
    let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let image = wholeImage, let rect = rect else {
      return wholeImage
    }
    
    let scale = image.scale
    let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
    
    guard let cgImage = image.cgImage?.cropping(to: scaledRect) else {
      return nil
    }
    return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
  }
}
