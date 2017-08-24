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
  
  @IBOutlet private var titleLabel: NSTextField!
  @IBOutlet private var stepsLabel: NSTextField!
  @IBOutlet private var versionLabel: NSTextField! {
    didSet {
      let bundle = Bundle.init(for: type(of: self))
      versionLabel.stringValue = bundle.appVersionFullString
    }
  }
  
  func set(title: String) {
    titleLabel.stringValue = title
  }
  
  func set(steps: Int) {
    stepsLabel.stringValue = "\(steps) steps"
  }
}
