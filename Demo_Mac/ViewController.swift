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
    return 6
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
    setupRenderView(with: .jellyFish, numberOfPopulation: 1000, fieldSize: Coordinate(6000, 4000))
  }

  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    resume()
  }
}
