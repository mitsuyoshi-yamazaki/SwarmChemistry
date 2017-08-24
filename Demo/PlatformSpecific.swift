//
//  PlatformSpecific.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/10.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
  typealias View = UIView
  typealias Nib = UINib
  typealias Window = UIWindow
#elseif os(macOS)
  import Cocoa
  typealias View = NSView
  typealias Nib = NSNib
  typealias Window = NSWindow
#endif
