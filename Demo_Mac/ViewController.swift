//
//  ViewController.swift
//  Demo_Mac
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

class ViewController: NSViewController {

  @IBOutlet private weak var renderView: SwarmRenderView!
  
  private var isRunning = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    
    step()
  }
  
  // MARK: -
  private func setup() {
    isRunning = false

    let numberOfPopulation = 1000
    let fieldSize = Coordinate(6000, 4000)

    renderView.population = Population.init(Recipe.jellyFish,
                                            numberOfPopulation: numberOfPopulation,
                                            fieldSize: fieldSize)
    // More recipes see: http://bingweb.binghamton.edu/~sayama/SwarmChemistry/
  }
  
  private func step() {
    isRunning = true
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.renderView.population?.step(6)
      DispatchQueue.main.async {
        self.renderView.setNeedsDisplay(self.renderView.bounds)
        guard self.isRunning else {
          return
        }
        self.step()
      }
    }
  }
  
  // MARK: - 
  @IBAction func reset(sender: AnyObject!) {
    setup()
    step()
  }
}

func random() -> Int {
  return Int(arc4random())
}
