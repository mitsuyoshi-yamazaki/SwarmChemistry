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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    if renderView.population.isEmpty {
      setup()
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    
    step()
  }
  
  // MARK: -
  private func setup() {
    let genomes: [Parameters] = [
      [25.0, 1.0, 2.0, 0.25, 0.25, 75.0, 0.35, 0.75],
      [50.0, 1.0, 2.0, 0.165, 1.0, 35.0, 0.25, 0.5],
      [15.0, 1.0, 2.0, 1.05, 0.8, 25.0, 0.333, 0.25],
      [20.0, 1.0, 2.0, 0.115, 0.8, 50.0, 0.25, 0.675],
      ]
      .map { Parameters($0)! }
    
    let genomeCount = genomes.count
    let width = Int(renderView.frame.width)
    let height = Int(renderView.frame.height)
    let fieldSize = Coordinate(width, height)
    
    let population: [Individual] = (0..<500)
      .map { _ in Coordinate(random() % width, random() % height) }
      .map { Individual.init(fieldSize: fieldSize, position: $0, genome: genomes[random() % genomeCount]) }
    
    renderView.population = population
  }
  
  private func step() {

    renderView.population.step()
    renderView.setNeedsDisplay(renderView.bounds)
    
    DispatchQueue.main.async {
      self.step()
    }
  }
}

func random() -> Int {
  return Int(arc4random())
}

class RenderView: NSView {
  
  var population: [Individual] = []
  var cellSize = 2.0

  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }

    let size = cellSize
    
    context.setFillColor(NSColor.white.cgColor)
    context.fill(bounds)
    
    for individual in population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: individual.position.x, y: individual.position.y, width: size, height: size))
    }
  }
}
