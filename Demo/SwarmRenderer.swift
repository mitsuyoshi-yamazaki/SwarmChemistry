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
  var steps: Int { get }
  
  func setupRenderView(with recipe: Recipe?, numberOfPopulation: Int, fieldSize: Vector2)
  func step()
  func pause()
  func resume()
}

extension SwarmRenderer {
  func setupRenderView(with recipe: Recipe?, numberOfPopulation: Int, fieldSize: Vector2) {
    isRunning = false

    renderView.population = Population.init(recipe ?? Recipe.none(),
                                            numberOfPopulation: numberOfPopulation,
                                            fieldSize: fieldSize)
  }
  
  func step() {
    guard isRunning == true else {
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.renderView.population?.step(self.steps)
      DispatchQueue.main.async {
        guard self.isRunning == true else {
          return  // Without this, setNeedsDisplay() maybe called one time after pause() call
        }
        self.renderView.setNeedsDisplay(self.renderView.bounds)
        self.step()
      }
    }
  }
  
  func pause() {
    isRunning = false
  }
  
  func resume() {
    isRunning = true
    step()
  }
}
