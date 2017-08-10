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

  @IBOutlet private weak var renderView: RenderView!
  
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

class RenderView: NSView {
  
  var population: Population?
  var cellSize: CGFloat = 16.0

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }
    context.setFillColor(NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor)
    context.fill(bounds)

    guard let population = population else {
      return
    }

    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let multiplier = min(frame.width / fieldWidth, frame.height / fieldHeight)
    let size = cellSize * multiplier
    
    context.setFillColor(NSColor.white.cgColor)
    context.fill(.init(x: 0.0, y: 0.0, width: fieldWidth * multiplier, height: fieldHeight * multiplier))
    
    for individual in population.population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * multiplier, y: CGFloat(individual.position.y) * multiplier, width: size, height: size))
    }
  }
}
