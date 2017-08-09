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
    
//    let genomes: [Parameters] = [
//      [25.0, 1.0, 2.0, 0.25, 0.25, 75.0, 0.35, 0.75],
//      [50.0, 1.0, 2.0, 0.165, 1.0, 35.0, 0.25, 0.5],
//      [15.0, 1.0, 2.0, 1.05, 0.8, 25.0, 0.333, 0.25],
//      [20.0, 1.0, 2.0, 0.115, 0.8, 50.0, 0.25, 0.675],
//      ]
//      .map { Parameters($0)! }
//    let genomeCount = genomes.count

    let numberOfPopulation = 1300
    let genomeCount = numberOfPopulation / 50
  
    let genomes: [Parameters] = (0..<genomeCount)
      .map { _ in Parameters.random }
    
    let width = Int(renderView.frame.width)
    let height = Int(renderView.frame.height)
    
    let population: [Individual] = (0..<numberOfPopulation)
      .map { _ in Coordinate(random() % width, random() % height) }
      .map { Individual.init(position: $0, genome: genomes[random() % genomeCount]) }
//      .map { Individual.init(position: $0, genome: Parameters.random) }
 
    let fieldSize = Coordinate(width, height)

    renderView.population = Population.init(fieldSize: fieldSize, population: population)
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
}

func random() -> Int {
  return Int(arc4random())
}

class RenderView: NSView {
  
  var population: Population?
  var cellSize: CGFloat = 2.0

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
