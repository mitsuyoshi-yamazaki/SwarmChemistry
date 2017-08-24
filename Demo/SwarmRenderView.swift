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

  var cellSize: CGFloat = 16.0
  var population = Population.empty() {
    didSet {
      updateFieldSizeMultiplier()
    }
  }

  fileprivate var fieldSizeMultiplier: CGFloat = 1.0
  fileprivate var shouldClear = false
  
  private func updateFieldSizeMultiplier() {
    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    fieldSizeMultiplier = min(frame.width / fieldWidth, frame.height / fieldHeight)
  }
  
  // MARK: - Draw
  #if os(iOS) || os(watchOS) || os(tvOS)
  override func layoutSubviews() {
    super.layoutSubviews()
    updateFieldSizeMultiplier()
  }

  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    draw(with: context)
  }
  #elseif os(macOS)
  override func layout() {
    super.layout()
    updateFieldSizeMultiplier()
  }
  
  override func draw(_ dirtyRect: NSRect) {
    guard let context = NSGraphicsContext.current()?.cgContext else {
      fatalError()
    }
    draw(with: context)
  }
  #endif
  
  private func draw(with context: CGContext) {
    guard shouldClear == false else {
      shouldClear = false
      context.setFillColor(Color.white.cgColor)
      context.fill(bounds)
      return
    }
    
    context.setFillColor(Color(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor)
    context.fill(bounds)
    
    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let size = cellSize * fieldSizeMultiplier
    
    context.setFillColor(Color.white.cgColor)
    context.fill(.init(x: 0.0, y: 0.0, width: fieldWidth * fieldSizeMultiplier, height: fieldHeight * fieldSizeMultiplier))
    
    for individual in population.population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * fieldSizeMultiplier, y: CGFloat(individual.position.y) * fieldSizeMultiplier, width: size, height: size))
    }
  }
}

// MARK: - Function
extension SwarmRenderView {
  func clear() {
    shouldClear = true
    setNeedsDisplay(bounds)
  }
  
  func convert(_ rect: CGRect) -> Vector2.Rect {
    return Vector2.Rect(rect) / Value(fieldSizeMultiplier)
  }
}
