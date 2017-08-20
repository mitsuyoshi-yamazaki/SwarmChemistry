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
