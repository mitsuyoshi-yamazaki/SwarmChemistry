//
//  Demo_ScreenSaverView.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/23.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import ScreenSaver
import SwarmChemistry

// https://developer.apple.com/documentation/screensaver
class Demo_ScreenSaverView: ScreenSaverView {
  
  private var population = Population.init(Recipe.jellyFish, numberOfPopulation: 1000, fieldSize: Vector2(1000, 1000), initialArea: Vector2.Rect.init(x: 400, y: 400, width: 200, height: 200))
  private var isRunning = false {
    didSet {
      guard isRunning != oldValue else {
        return
      }
      if isRunning {
        step()
      }
    }
  }
  
  override var animationTimeInterval: TimeInterval {
    get {
      return 0.5
    }
    set {}
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
  }
  
  override func startAnimation() {
    super.startAnimation()
    isRunning = true
  }
  
  func step() {
    guard isRunning else {
      return
    }
    DispatchQueue.global().async {
      self.population.step(10)
      self.step()
    }
  }
  
  override func stopAnimation() {
    super.stopAnimation()
    isRunning = false
  }
  
  override func draw(_ rect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }
    
    context.setFillColor(Color(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor)
    context.fill(bounds)
    
    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let fieldSizeMultiplier = min(frame.width / fieldWidth, frame.height / fieldHeight)

    let size = 10.0 * fieldSizeMultiplier
    
    context.setFillColor(Color.white.cgColor)
    context.fill(NSRect.init(x: 0.0, y: 0.0, width: fieldWidth * fieldSizeMultiplier, height: fieldHeight * fieldSizeMultiplier))
    
    for individual in population.population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * fieldSizeMultiplier, y: CGFloat(individual.position.y) * fieldSizeMultiplier, width: size, height: size))
    }
  }
  
  // 30fps
  override func animateOneFrame() {
    setNeedsDisplay(bounds)
  }
  
  override func hasConfigureSheet() -> Bool {
    return false
  }
  
  override func configureSheet() -> NSWindow? {
    return nil
  }
}
