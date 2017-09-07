//
//  PlatformSpecific.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
  public typealias Color = UIColor
#elseif os(macOS)
  import Cocoa
  public typealias Color = NSColor
#endif
