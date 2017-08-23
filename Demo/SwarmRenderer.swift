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
  var delay: Double { get }
  
  func setupRenderView(with population: Population)
  func step()
  func pause()
  func resume()
  func clear()
  
  func didStep(currentSteps: Int)
}

extension SwarmRenderer {
  var delay: Double {
    return 0.0
  }

  func setupRenderView(with population: Population) {
    isRunning = false
    renderView.population = population
  }
  
  func step() {
    guard isRunning == true else {
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.renderView.population.step(self.steps)
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
        self.didStep(currentSteps: self.renderView.population.steps)
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
  
  func clear() {
    pause()
    renderView.clear()
  }
  
  func didStep(currentSteps: Int) {
    // Default implementation: does nothing
  }
}
