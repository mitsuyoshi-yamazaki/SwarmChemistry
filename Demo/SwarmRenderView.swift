//
//  SwarmRenderView.swift
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

class SwarmRenderView: View {

  var population = Population.zero()
  var cellSize: CGFloat = 16.0

  #if os(iOS) || os(watchOS) || os(tvOS)
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    draw(with: context)
  }
  #elseif os(macOS)
  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }
    draw(with: context)
  }
  #endif
  
  private func draw(with context: CGContext) {

    context.setFillColor(Color(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor)
    context.fill(bounds)
    
    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let multiplier = min(frame.width / fieldWidth, frame.height / fieldHeight)
    let size = cellSize * multiplier
    
    context.setFillColor(Color.white.cgColor)
    context.fill(.init(x: 0.0, y: 0.0, width: fieldWidth * multiplier, height: fieldHeight * multiplier))
    
    for individual in population.population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * multiplier, y: CGFloat(individual.position.y) * multiplier, width: size, height: size))
    }
  }
}
