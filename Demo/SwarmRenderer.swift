//
//  SwarmRenderer.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/10.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
#elseif os(macOS)
  import Cocoa
#endif

import SwarmChemistry

protocol SwarmRenderer: class {
  weak var renderView: SwarmRenderView! { set get }
  var isRunning: Bool { set get }
  
  func setupRenderView(with recipe: Recipe?, numberOfPopulation: Int, fieldSize: Coordinate)
  func stepSwarm()
}

extension SwarmRenderer {
  func setupRenderView(with recipe: Recipe?, numberOfPopulation: Int, fieldSize: Coordinate) {
    isRunning = false

    renderView.population = Population.init(recipe ?? Recipe.random(numberOfGenomes: 5),
                                            numberOfPopulation: numberOfPopulation,
                                            fieldSize: fieldSize)
  }
  
  func stepSwarm() {
    guard isRunning == false else {
      return
    }
    isRunning = true
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.renderView.population?.step(6)
      DispatchQueue.main.async {
        self.renderView.setNeedsDisplay(self.renderView.bounds)
        guard self.isRunning else {
          return
        }
        self.isRunning = false
        self.stepSwarm()
      }
    }
  }
}
