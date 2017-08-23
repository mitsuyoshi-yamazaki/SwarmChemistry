//
//  ViewController.swift
//  Demo_Mac
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

class ViewController: NSViewController, SwarmRenderer {

  @IBOutlet weak var clickGestureRecognizer: NSClickGestureRecognizer!
  @IBOutlet weak var resumeButton: NSButton!
  private var dragIndicatorView: NSView = {
    let view = NSBox.init()

    view.boxType = .custom
    view.fillColor = NSColor.init(white: 0.2, alpha: 0.2)
    view.borderType = .noBorder
    view.isHidden = true
    
    return view
  }()
  
  private var mouseDownLocation: NSPoint?
  
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
    return 2
  }
  var delay: Double {
    return 0.0
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    let fieldSize = Vector2(3000, 3000)
    let population = Population.init(Recipe.oscillator,
                                     numberOfPopulation: 2000,
                                     fieldSize: fieldSize,
                                     initialArea: Vector2.Rect.init(origin: fieldSize * 0.1, size: fieldSize * 0.8))

    setupRenderView(with: population)
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
