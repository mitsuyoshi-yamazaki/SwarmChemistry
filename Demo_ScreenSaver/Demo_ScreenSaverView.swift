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
  
  #if AT_HOME
  private let fieldSizeMultiplier: CGFloat = 0.15
  private let steps = 1
  #else
  private let fieldSizeMultiplier: CGFloat = 0.25
  private let steps = 10
  #endif
  
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
      #if AT_HOME
        return isPreview ? 0.15 : 5.0
      #else
        return 0.15
      #endif
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
    
    setupSwarmChemistry()
  }
  
  fileprivate func setupSwarmChemistry() {
    let width = Int(frame.size.width / fieldSizeMultiplier)
    let height = Int(frame.size.height / fieldSizeMultiplier)
    let fieldSize = Vector2(width, height)
    let initialArea = Vector2.Rect.init(origin: fieldSize * 0.2, size: fieldSize * 0.6)
    
    #if AT_HOME
      let numberOfPopulation = isPreview ? 1000 : 5000
      let recipe = Recipe.random(numberOfGenomes: 20, fieldSize: fieldSize.rect)
      population = Population.init(recipe,
                                   numberOfPopulation: numberOfPopulation,
                                   fieldSize: fieldSize,
                                   initialArea: initialArea)
      contentView.set(title: "ArtificialLife@Home")
    #else
      let recipe = selectedRecipe ?? Recipe.jellyFish
      
      population = Population.init(recipe,
                                   numberOfPopulation: 1000,
                                   fieldSize: fieldSize,
                                   initialArea: initialArea)
      contentView.set(title: population.recipe.name)
    #endif
    
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
      self.population.step(self.steps)
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
    #if AT_HOME
      return false
    #else
      return isPreview
    #endif
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
    selectedRecipe = recipe
    setupSwarmChemistry()
  }
}

// FixMe: Cannot separate following members to a different class.. the system calls init(frame: isPreview:) to the class and it crashes
extension Demo_ScreenSaverView {
  fileprivate var moduleName: String {
    let bundle = Bundle.init(for: type(of: self))
    return bundle.bundleIdentifier!
  }
  
  fileprivate var defaults: ScreenSaverDefaults {
    return ScreenSaverDefaults.init(forModuleWithName: moduleName)!
  }
  
  fileprivate func fullKey(of key: String) -> String {
    return moduleName + "." + key
  }
}

extension Demo_ScreenSaverView {
  fileprivate var selectedRecipe: Recipe? {
    get {
      guard let recipeName = defaults.object(forKey: fullKey(of: "selectedRecipeName")) as? String else {
        return nil
      }
      return Recipe.presetRecipes.filter { $0.name == recipeName }.first
    }
    set {
      let defaults = self.defaults
      defaults.set(newValue?.name, forKey: fullKey(of: "selectedRecipeName"))
      defaults.synchronize()
    }
  }
}

