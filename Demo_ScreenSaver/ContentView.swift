//
//  ContentView.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/24.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa

final class ContentView: NSView, IBInstantiatable {
  
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
