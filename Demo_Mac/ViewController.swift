//
//  ViewController.swift
//  Demo_Mac
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

class ViewController: NSViewController {//, SwarmRenderer {
  enum Mode {
    case interactive
    case overNight
  }
  
  @IBOutlet weak var clickGestureRecognizer: NSClickGestureRecognizer!
  @IBOutlet weak var contentView: NSView!
  @IBOutlet weak var resumeButton: NSButton!
  private var dragIndicatorView: NSView = {
    let view = NSBox.init()

    view.boxType = .custom
    view.fillColor = NSColor.init(white: 0.2, alpha: 0.2)
    view.borderType = .noBorder
    view.isHidden = true
    
    return view
  }()
  private let statusView: StatusView = {
    let view = StatusView.instantiate()
    view.autoresizingMask = [ NSAutoresizingMaskOptions.viewHeightSizable, .viewWidthSizable ]
    
    return view
  }()

  private var mouseDownLocation: NSPoint?
  private var mode = Mode.interactive
  
  // MARK: - SwarmRenderer
  @IBOutlet weak var renderView: SwarmRenderView!
  var isRunning = false {
    didSet {
      if isRunning {
        resumeButton?.isHidden = true
        clickGestureRecognizer?.isEnabled = true
      } else {
        resumeButton?.isHidden = false
        clickGestureRecognizer?.isEnabled = false
      }
    }
  }
  var steps: Int {
    switch mode {
    case .interactive:
      return 3
    case .overNight:
      return 100
    }
  }
  var delay: Double {
    return 0.0
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    statusView.frame = view.bounds
    view.addSubview(statusView, positioned: NSWindowOrderingMode.below, relativeTo: contentView)
    
    setup()
    
    view.addSubview(dragIndicatorView)
    
    let temp = isRunning
    isRunning = temp  // To call didSet
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    resume()
  }
  
  // MARK: - Function
  private func setup() {
    let population: Population
    let recipe: Recipe
    
    switch mode {
    case .interactive:
      let fieldSize = Vector2(6000, 4000)
      recipe = Recipe.jellyFish
      population = Population.init(recipe,
                                   numberOfPopulation: 1200,
                                   fieldSize: fieldSize,
                                   initialArea: Vector2.Rect.init(origin: fieldSize * 0.2, size: fieldSize * 0.6))
    case .overNight:
      let fieldSize = Vector2(10000, 8000)
      recipe = Recipe.random(numberOfGenomes: 20, fieldSize: fieldSize.rect)
      population = Population.init(recipe,
                                   numberOfPopulation: 5000,
                                   fieldSize: fieldSize,
                                   initialArea: Vector2.Rect.init(origin: fieldSize * 0.3, size: fieldSize * 0.4))
    }
    
    let recipeText = recipe.description
    let recipeData = recipeText.data(using: .utf16)
    let fileURL = URL.init(fileURLWithPath: Date().description + ".txt")

    try? recipeData?.write(to: fileURL)
    
    statusView.set(title: recipe.name)
    setupRenderView(with: population)
  }
  
  private func saveScreenshotToFile() {
    guard let screenshot = renderView.takeScreenshot() else {
      print("Saving screenshot failed: cannot take a screenshot")
      return
    }
    guard let tiffRepresentation = screenshot.tiffRepresentation else {
      print("Saving screenshot failed: cannot obtain a tiff representation")
      return
    }
    let bitmapImageRepresentation = NSBitmapImageRep.init(data: tiffRepresentation)
    guard let data = bitmapImageRepresentation?.representation(using: .PNG, properties: [:]) else {
      print("Saving screenshot failed: cannot obtain image data")
      return
    }
    
    let fileURL = URL.init(fileURLWithPath: Date().description + ".png")
    
    do {
      try data.write(to: fileURL)
    } catch {
      print("Saving screenshot failed: cannot save a screenshot to file: \(error)")
    }
  }

  func didStep(currentSteps: Int) {
    statusView.set(steps: currentSteps)
    
    switch mode {
    case .overNight:
      saveScreenshotToFile()
      (0..<10).forEach { _ in
        self.renderView.population.step(self.steps / 20)
        saveScreenshotToFile()
      }
      
      if currentSteps >= 4000 {
        pause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { 
          self.setup()
          self.resume()
        })
      }
    default:
      break
    }
  }
  
  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    resume()
  }
  
  @IBAction func clear(sender: AnyObject!) {
    clear()
  }
  
  @IBAction func pause(sender: AnyObject!) {
    pause()
  }
  
  @IBAction func resume(sender: AnyObject!) {
    resume()
  }

  @IBAction func changeMode(sender: AnyObject!) {
    switch mode {
    case .interactive:
      mode = .overNight
    case .overNight:
      mode = .interactive
    }
  }

  // MARK: -
  override func mouseDown(with event: NSEvent) {
    let mouseDownLocation = event.locationInWindow // Currently the render view fills its window.
    self.mouseDownLocation = mouseDownLocation
    
    dragIndicatorView.frame = NSRect.init(origin: mouseDownLocation, size: .zero)
    dragIndicatorView.isHidden = false
  }
  
  override func mouseDragged(with event: NSEvent) {
    guard let mouseDownLocation = mouseDownLocation else {
      print("Something wrong: \"mouseDownLocation\" is nil")
      return
    }
    let mouseDraggedLocation = event.locationInWindow
    
    dragIndicatorView.frame = NSRect.init(point1: mouseDownLocation, point2: mouseDraggedLocation)
  }
  
  override func mouseUp(with event: NSEvent) {
    defer {
      dragIndicatorView.isHidden = true
    }
    guard let mouseDownLocation = mouseDownLocation else {
      print("Something wrong: \"mouseDownLocation\" is nil")
      return
    }
    let mouseUpLocation = event.locationInWindow

    let rect = NSRect.init(point1: mouseDownLocation, point2: mouseUpLocation)
    let swarmRect = renderView.convert(rect)
    let recipe = renderView.population.recipe(in: swarmRect)
    let recipeText = recipe.description
    print(recipeText)
    
    NSPasteboard.general().declareTypes([NSPasteboardTypeString], owner: nil)
    NSPasteboard.general().setString(recipeText, forType: NSPasteboardTypeString)
    
    self.mouseDownLocation = nil
  }
}

extension ViewController {
  func setupRenderView(with population: Population) {
    isRunning = false
    renderView.population = population
  }
  
  func step() {
    guard isRunning == true else {
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.renderView.population.step(self.steps)
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
        self.didStep(currentSteps: self.renderView.population.steps)
        guard self.isRunning == true else {
          return  // Without this, setNeedsDisplay() maybe called one time after pause() call
        }
        self.renderView.setNeedsDisplay(self.renderView.bounds)
        self.step()
      }
    }
  }
  
  func pause() {
    isRunning = false
  }
  
  func resume() {
    isRunning = true
    step()
  }
  
  func clear() {
    pause()
    renderView.clear()
  }
}

extension NSRect {
  init(point1: NSPoint, point2: NSPoint) {
    let x = min(point1.x, point2.x)
    let y = min(point1.y, point2.y)
    let width = abs(point2.x - point1.x)
    let height = abs(point2.y - point1.y)
    
    origin = NSPoint.init(x: x, y: y)
    size = NSSize.init(width: width, height: height)
  }
}

extension NSView {
  func takeScreenshot(_ rect: NSRect? = nil) -> NSImage? {
    
    let screenshotRect = rect ?? bounds
    guard let bitmapRepresentation = bitmapImageRepForCachingDisplay(in: screenshotRect) else {
      print("Fail to capture screenshot: bitmapImageRep")
      return nil
    }
    cacheDisplay(in: screenshotRect, to: bitmapRepresentation)
    
    let image = NSImage.init(size: screenshotRect.size)
    image.addRepresentation(bitmapRepresentation)
    
    return image
  }
}
