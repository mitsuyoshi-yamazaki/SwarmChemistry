//
//  ContentView.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/24.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa

class ContentView: NSView {
  
  static func instantiate() -> ContentView {
    var topLevelObjects = NSArray()
    let nibName = String.init(describing: self)
    let bundle = Bundle.init(for: self)

    bundle.loadNibNamed(nibName, owner: self, topLevelObjects: &topLevelObjects)
    
    return topLevelObjects.filter { $0 is ContentView }.first as! ContentView
  }
}
