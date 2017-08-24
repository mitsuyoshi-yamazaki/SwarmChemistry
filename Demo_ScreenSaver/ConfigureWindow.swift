//
//  ConfigureWindow.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/24.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

protocol ConfigureWindowDelegate: class {
  func configureWindow(_ window: ConfigureWindow, didSelect recipe: Recipe)
}

final class ConfigureWindow: NSWindow, IBInstantiatable {

  weak var configureWindowDelegate: ConfigureWindowDelegate?
  
  @IBAction func ok(sender: AnyObject!) {
    NSApp.endSheet(self)
//    endSheet(self)  // Doesn't work
  }
  
  @IBAction func cancel(sender: AnyObject!) {
    NSApp.endSheet(self)
    //    endSheet(self)  // Doesn't work
  }
}
