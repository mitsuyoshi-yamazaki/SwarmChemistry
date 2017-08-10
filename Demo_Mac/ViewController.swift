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

    let numberOfPopulation = 1300
    let fieldSize = Coordinate(2000, 2000)

    let recipeInsurmountableWall = ""
    + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.8, 0.01, 0.64)\n"
    + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.6)\n"
    + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.0)\n"
    + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)\n"
    
    let recipeCellWithTwoNuclei = ""
    + "41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)\n"
    + "26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)\n"
    + "30 * (277.87, 15.02, 24.44, 0.68, 0.05, 82.96, 0.43, 0.9)\n"
    + "28 * (110.8, 16.12, 38.6, 0.18, 0.34, 14.3, 0.01, 0.01)\n"
    + "48 * (83.79, 13.29, 7.54, 0.08, 0.79, 1.07, 0.15, 0.45)\n"
    + "74 * (269.64, 6.62, 34.69, 0.36, 0.5, 30.2, 0.03, 0.23)\n"

    let recipeMulticellularity = ""
    + "99 * (19.8, 15.73, 2.61, 0.85, 0.64, 10.51, 0.17, 0.06)\n"
    + "48 * (300.0, 14.63, 0.0, 0.48, 0.81, 90.27, 0.25, 0.78)\n"
    + "37 * (275.18, 16.9, 7.05, 0.48, 0.81, 90.27, 0.17, 0.85)\n"
    + "8 * (159.59, 2.09, 24.19, 0.96, 0.59, 76.03, 0.01, 0.07)\n"
    + "42 * (73.07, 1.82, 2.36, 0.27, 0.61, 40.55, 0.22, 0.86)\n"

    let recipeJellyFish = ""
    + "134 * (262.65, 12.01, 25.87, 0.97, 1.0, 56.35, 0.26, 0.61)\n"
    + "67 * (288.17, 6.19, 23.37, 0.95, 1.0, 1.31, 0.1, 0.9)\n"
    + "68 * (150.5, 12.97, 15.87, 0.46, 0.39, 57.95, 0.17, 0.48)\n"
    
    renderView.population = Population.init(recipeCellWithTwoNuclei,
                                            numberOfPopulation: numberOfPopulation,
                                            fieldSize: fieldSize)!
    // More recipes see: http://bingweb.binghamton.edu/~sayama/SwarmChemistry/
  }
  
  private func step() {
    isRunning = true
    
    renderView.population?.step(3)
    renderView.setNeedsDisplay(renderView.bounds)
    
    DispatchQueue.main.async {
      guard self.isRunning else {
        return
      }
      self.step()
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
  var cellSize: CGFloat = 10.0

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
