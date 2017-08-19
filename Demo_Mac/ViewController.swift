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

  // MARK: - SwarmRenderer
  @IBOutlet weak var renderView: SwarmRenderView!
  var isRunning = false
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
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    resume()
  }
  
  // MARK: - Function
  private func setup() {
    
    let fieldSize = Vector2(3000, 3000)
    let population = Population.init(Recipe.oscillator,
                                     numberOfPopulation: inner + outer,
                                     fieldSize: fieldSize,
                                     initialArea: Vector2.Rect.init(origin: fieldSize * 0.4, size: fieldSize * 0.1))

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
}
