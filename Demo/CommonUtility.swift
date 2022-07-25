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
    guard let appVersion = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
      fatalError("Missing CFBundleShortVersionString")
    }
    return appVersion
  }

  var buildNumber: String {
    guard let buildNumber = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
      fatalError("Missing CFBundleVersion")
    }
    return buildNumber
  }

  var appVersionFullString: String {
    return "ver. \(appVersion)(\(buildNumber))"
  }
}

protocol IBInstantiatable: AnyObject {
  static var ibFileName: String { get }
  static var nib: Nib { get }

  static func instantiate() -> Self
}

extension IBInstantiatable {
  static var ibFileName: String {
    return String(describing: self)
  }
}

#if os(iOS) || os(watchOS) || os(tvOS)
#elseif os(macOS)
extension IBInstantiatable where Self: View {
  static var nib: Nib {
    let bundle = Bundle(for: self)
    guard let nib = Nib(nibNamed: ibFileName, bundle: bundle) else {
      fatalError("Missing nib file")
    }
    return nib
  }

  static func instantiate() -> Self {
    var topLevelObjects: NSArray? = NSArray()
    let bundle = Bundle(for: self)

    bundle.loadNibNamed(ibFileName, owner: self, topLevelObjects: &topLevelObjects)

    guard let view = topLevelObjects?.first(where: { $0 is Self }) as? Self else {
      fatalError("The top level object in \(ibFileName) is not \(self)")
    }
    return view
  }
}

// The codes are completely same as `extension IBInstantiatable where Self: View` 
// But NSWindow does not inherit NSView and `where` clause does not support `where Self: NSView or NSWindow`
extension IBInstantiatable where Self: Window {
  static var nib: Nib {
    let bundle = Bundle(for: self)
    guard let nib = Nib(nibNamed: ibFileName, bundle: bundle) else {
      fatalError("Missing nib file")
    }
    return nib
  }

  static func instantiate() -> Self {
    var topLevelObjects: NSArray? = NSArray()
    let bundle = Bundle(for: self)

    bundle.loadNibNamed(ibFileName, owner: self, topLevelObjects: &topLevelObjects)

    guard let window = topLevelObjects?.first(where: { $0 is Self }) as? Self else {
      fatalError("The top level object in \(ibFileName) is not \(self)")
    }
    return window
  }
}
#endif
