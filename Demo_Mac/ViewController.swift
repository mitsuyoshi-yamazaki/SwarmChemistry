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
    mouseDownLocation = event.locationInWindow // If the view structure is changed,
  }
  
  override func mouseUp(with event: NSEvent) {
    guard let mouseDownLocation = mouseDownLocation else {
      print("Something wrong: \"mouseDownLocation\" is nil")
      return
    }
    let mouseUpLocation = event.locationInWindow
    
    let x = min(mouseDownLocation.x, mouseUpLocation.x)
    let y = min(mouseDownLocation.y, mouseUpLocation.y)
    let width = abs(mouseUpLocation.x - mouseDownLocation.x)
    let height = abs(mouseUpLocation.y - mouseDownLocation.y)
    
    let rect = CGRect.init(x: x, y: y, width: width, height: height)
    let swarmRect = renderView.convert(rect)
    let recipe = renderView.population.recipe(in: swarmRect)
    
    NSPasteboard.general().declareTypes([NSPasteboardTypeString], owner: nil)
    NSPasteboard.general().setString(recipe.description, forType: NSPasteboardTypeString)
    
    self.mouseDownLocation = nil
  }
}
