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
class Demo_ScreenSaverView: ScreenSaverView, SwarmRenderer {
  
  private let contentView: ContentView = {
    let view = ContentView.instantiate()
    return view
  }()
  
  private lazy var configureWindow: ConfigureWindow = {
    let window = ConfigureWindow.instantiate()
    return window
  }()
  
  fileprivate var recipeID: Int?
  
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
  
  // MARK: - SwarmRenderer
  var renderView: SwarmRenderView! = {
    let view = SwarmRenderView()
    return view
  }()
  var isRunning = false {
    didSet {
      guard isRunning != oldValue else {
        return
      }
      if isRunning {
        step()
      }
    }
  }
  var delay: Double {
    return 0.0
  }
  #if AT_HOME
  private let fieldSizeMultiplier: CGFloat = 0.15
  var steps = 1
  #else
  private let fieldSizeMultiplier: CGFloat = 0.25
  var steps = 10
  #endif

  // MARK: -
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)
    setup()
  }
  
  private func setup() {
    renderView.frame = bounds
    addSubview(renderView)
    
    contentView.frame = bounds
    addSubview(contentView)
    
    setupSwarmChemistry()
  }
  
  fileprivate func setupSwarmChemistry() {
    let width = Int(frame.size.width / fieldSizeMultiplier)
    let height = Int(frame.size.height / fieldSizeMultiplier)
    let fieldSize = Vector2(width, height)
    let initialArea = Vector2.Rect.init(origin: fieldSize * 0.2, size: fieldSize * 0.6)
    let population: Population
    
    #if AT_HOME
      let numberOfPopulation = isPreview ? 1000 : 5000
      let recipe = Recipe.random(numberOfGenomes: 20, fieldSize: fieldSize.rect)
      population = Population.init(recipe,
                                   numberOfPopulation: numberOfPopulation,
                                   fieldSize: fieldSize,
                                   initialArea: initialArea)
      contentView.set(title: "ArtificialLife@Home")
      send(recipe: recipe)
    #else
      let recipe = selectedRecipe ?? Recipe.jellyFish
      
      population = Population.init(recipe,
                                   numberOfPopulation: 1000,
                                   fieldSize: fieldSize,
                                   initialArea: initialArea)
      contentView.set(title: population.recipe.name)
    #endif
    
    contentView.set(steps: population.steps)
    setupRenderView(with: population)
  }
  
  override func startAnimation() {
    super.startAnimation()
    resume()
  }
  
  override func stopAnimation() {
    super.stopAnimation()
    pause()
  }
  
  override func animateOneFrame() {
    contentView.set(steps: renderView.population.steps)
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
    configureWindow.selectedRecipe = renderView.population.recipe
    
    return configureWindow
  }
}

extension Demo_ScreenSaverView: ConfigureWindowDelegate {
  func configureWindow(_ window: ConfigureWindow, didSelect recipe: Recipe) {
    selectedRecipe = recipe
    setupSwarmChemistry()
  }
}

// Network
extension Demo_ScreenSaverView {
  fileprivate func send(recipe: Recipe) {
    guard isPreview == false else {
      return
    }
    guard let data = try? JSONSerialization.data(withJSONObject: ["raw": recipe.description], options: []) else {
      Swift.print("Serializing to JSON failed")
      return
    }
    
    let path = Constants.dataServerURL + "recipes"
    let url = URL.init(string: path)!
    var request = URLRequest.init(url: url)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = data
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard
        let nonNilData = data,
        error == nil,
        let result = try? JSONSerialization.jsonObject(with: nonNilData, options: []) as? [String: Any]
      else {
        Swift.print("Failed to send recipe")
        return
      }
      guard let recipeID = result?["id"] as? Int else {
        Swift.print("Faild to parse the response data")
        Swift.print(String.init(describing: result))
        return
      }
      Swift.print("Sending recipe succeeded")
      self.recipeID = recipeID
    }
    task.resume()
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

