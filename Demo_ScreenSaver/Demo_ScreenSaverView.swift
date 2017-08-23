//
//  Demo_ScreenSaverView.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/23.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import ScreenSaver

class Demo_ScreenSaverView: ScreenSaverView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.animationTimeInterval = 1.0 / 30.0
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
    self.animationTimeInterval = 1.0 / 30.0
  }
  
  override func startAnimation() {
    super.startAnimation()
  }
  
  override func stopAnimation() {
    super.stopAnimation()
  }
  
  override func draw(_ rect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }
    context.setFillColor(NSColor.blue.cgColor)
    context.fillEllipse(in: bounds)
  }
  
  override func animateOneFrame() {
    return
  }
  
  override func hasConfigureSheet() -> Bool {
    return false
  }
  
  override func configureSheet() -> NSWindow? {
    return nil
  }
}
