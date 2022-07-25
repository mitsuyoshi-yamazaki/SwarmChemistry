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

protocol SwarmRenderer: AnyObject {
  var renderView: SwarmRenderView! { set get }
  var timer: Timer? { set get }
  var steps: Int { get }
  var delay: Double { get }
  
  func setupRenderView(with population: Population)
  func pause()
  func start()
  func clear()
  
  func didStep(currentSteps: Int)
}

extension SwarmRenderer {
  var delay: Double {
    return 0.0
  }

  func setupRenderView(with population: Population) {
    renderView.population = population
    
    pause()
  }

  func pause() {
    timer?.invalidate()
    timer = nil
  }
  
  func start() {
    pause()
    
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true, block: { [weak self] _ in
      guard let self = self else { return }
      self.renderView.population.step(self.steps)
      self.didStep(currentSteps: self.renderView.population.steps)
      self.renderView.setNeedsDisplay(self.renderView.bounds)
    })
  }
  
  func clear() {
    pause()
    renderView.clear()
  }
  
  func didStep(currentSteps: Int) {
    // Default implementation: does nothing
  }
}
