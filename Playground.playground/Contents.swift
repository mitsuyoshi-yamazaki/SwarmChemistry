//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import SwarmChemistry

// Recommendation: run following command on terminal to ignore modifications on this file.
// $ git update-index --skip-worktree Playground.playground/Contents.swift

final class View: UIView {
  var population = Population.empty()
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!

    let fieldWidth = CGFloat(population.fieldSize.x)
    let fieldHeight = CGFloat(population.fieldSize.y)
    let fieldSizeMultiplier = min(frame.width / fieldWidth, frame.height / fieldHeight)
    let size = fieldSizeMultiplier * 12.0
    
    context.setFillColor(Color.white.cgColor)
    context.fill(.init(x: 0.0, y: 0.0, width: fieldWidth * fieldSizeMultiplier, height: fieldHeight * fieldSizeMultiplier))
    
    for individual in population.population {
      
      individual.genome.color.setFill()
      context.fillEllipse(in: CGRect(x: CGFloat(individual.position.x) * fieldSizeMultiplier, y: CGFloat(individual.position.y) * fieldSizeMultiplier, width: size, height: size))
    }
  }
}

// Setup Swarm
let recipe = Recipe.jellyFish
let fieldSize = Vector2(2000, 3000)
let initialArea = Vector2.Rect(origin: fieldSize * 0.2, size: fieldSize * 0.6)

let population = Population(recipe, numberOfPopulation: 160, fieldSize: fieldSize, initialArea: initialArea)

// Setup View
let frame = CGRect(x: 0, y: 0, width: 400, height: 600)
let view = View(frame: frame)
view.population = population

func step() {
  view.population.step(3)
  view.setNeedsDisplay()
  
  DispatchQueue.main.async {
    step()
  }
}

PlaygroundPage.current.liveView = view
step()
