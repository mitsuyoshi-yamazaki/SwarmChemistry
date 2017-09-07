//
//  CommonUtility.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/16.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
#elseif os(macOS)
  import Cocoa
#endif

import SwarmChemistry

extension Vector2.Rect {
  init(_ rect: CGRect) {
    self.init(x: Value(rect.origin.x), y: Value(rect.origin.y), width: Value(rect.size.width), height: Value(rect.size.height))
  }
}

extension Bundle {
  var appVersion: String {
    return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }
  
  var buildNumber: String {
    return object(forInfoDictionaryKey: "CFBundleVersion") as! String
  }
  
  var appVersionFullString: String {
    return "ver. \(appVersion)(\(buildNumber))"
  }
}

protocol IBInstantiatable: class {
  static var ibFileName: String { get }
  static var nib: Nib { get }
  
  static func instantiate() -> Self
}

extension IBInstantiatable {
  static var ibFileName: String {
    return String.init(describing: self)
  }
}

#if os(iOS) || os(watchOS) || os(tvOS)
#elseif os(macOS)
extension IBInstantiatable where Self: View {
  static var nib: Nib {
    let bundle = Bundle.init(for: self)
    return Nib.init(nibNamed: ibFileName, bundle: bundle)!
  }
  
  static func instantiate() -> Self {
    var topLevelObjects = NSArray()
    let bundle = Bundle.init(for: self)
    
    bundle.loadNibNamed(ibFileName, owner: self, topLevelObjects: &topLevelObjects)
    
    return topLevelObjects.filter { $0 is Self }.first as! Self
  }
}

// The codes are completely same as `extension IBInstantiatable where Self: View` 
// But NSWindow does not inherit NSView and `where` clause does not support `where Self: NSView or NSWindow`
extension IBInstantiatable where Self: Window {
  static var nib: Nib {
    let bundle = Bundle.init(for: self)
    return Nib.init(nibNamed: ibFileName, bundle: bundle)!
  }
  
  static func instantiate() -> Self {
    var topLevelObjects = NSArray()
    let bundle = Bundle.init(for: self)
    
    bundle.loadNibNamed(ibFileName, owner: self, topLevelObjects: &topLevelObjects)
    
    return topLevelObjects.filter { $0 is Self }.first as! Self
  }
}
#endif
