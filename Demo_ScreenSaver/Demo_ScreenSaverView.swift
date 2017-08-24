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
// TODO: Change class name & set it to Principal Class in Info.plist
class Demo_ScreenSaverView: ScreenSaverView {
  
  private let contentView: ContentView = {
    let view = ContentView.instantiate()
    return view
  }()
  
  private lazy var configureWindow: ConfigureWindow = {
    let window = ConfigureWindow.instantiate()
    return window
  }()
  
  private let fieldSizeMultiplier: CGFloat = 0.25
  private var population = Population.empty()
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
      return 0.15
    }
    set {}
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
    setup()
  }
  
  private func setup() {
    contentView.frame = bounds
    addSubview(contentView)
        
    let width = Int(frame.size.width / fieldSizeMultiplier)
    let height = Int(frame.size.height / fieldSizeMultiplier)
    let fieldSize = Vector2(width, height)
    let initialArea = Vector2.Rect.init(origin: fieldSize * 0.2, size: fieldSize * 0.6)
    
    population = Population.init(Recipe.jellyFish,
                                 numberOfPopulation: 1000,
                                 fieldSize: fieldSize,
                                 initialArea: initialArea)
    
    contentView.set(title: population.recipe.name)
    contentView.set(steps: population.steps)
  }
  
  override func startAnimation() {
    super.startAnimation()
    isRunning = true
  }
  
  private func step() {
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
    
    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let size = 20.0 * fieldSizeMultiplier
    
    context.setFillColor(Color.white.cgColor)
    context.fill(NSRect.init(x: 0.0, y: 0.0, width: fieldWidth * fieldSizeMultiplier, height: fieldHeight * fieldSizeMultiplier))
    
    for individual in population.population {
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * fieldSizeMultiplier, y: CGFloat(individual.position.y) * fieldSizeMultiplier, width: size, height: size))
    }
  }
  
  override func animateOneFrame() {
    contentView.set(steps: population.steps)
    setNeedsDisplay(bounds)
  }
  
  override func hasConfigureSheet() -> Bool {
    return isPreview
  }
  
  override func configureSheet() -> NSWindow? {
    guard isPreview else {
      return nil
    }
    configureWindow.configureWindowDelegate = self
    configureWindow.selectedRecipe = population.recipe
    
    return configureWindow
  }
}

extension Demo_ScreenSaverView: ConfigureWindowDelegate {
  func configureWindow(_ window: ConfigureWindow, didSelect recipe: Recipe) {
    Swift.print(#function)
  }
}
