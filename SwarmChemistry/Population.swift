//
//  Population.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Population
public struct Population {
  public var fieldSize = Vector2(500, 500)
  public var steps = 0
  public let population: [Individual]
  public let recipe: Recipe
}

// MARK: - Recipe
public extension Population {
  init(_ recipe: Recipe, numberOfPopulation: Int? = nil, fieldSize: Vector2 = Vector2(500, 500), initialArea: Vector2.Rect? = nil) {
    
    self.recipe = recipe
    
    let sum = recipe.genomes
      .reduce(0) { (result, value) -> Int in
        result + value.count
      }
    let magnitude = Value(numberOfPopulation ?? sum) / Value(sum)
    
    let area: Vector2.Rect
    if let initialArea = initialArea {
      area = initialArea
    } else {
      area = .init(origin: .zero, size: fieldSize)
    }
    
    population = recipe.genomes
      .map { value -> [Individual] in
        let count = Int(Value(value.count) * magnitude)
        return (0..<count)
          .map { _ in
            Individual(position: (value.area ?? area).random(), genome: value.genome)
          }
      }
      .flatMap { $0 }
    
    self.fieldSize = fieldSize
  }
}

// MARK: - Accessor
public extension Population {
  static func empty() -> Population {
    return Population.init(.none(), numberOfPopulation: 0, fieldSize: .zero)
  }
}

// MARK: - Function
public extension Population {
  func recipe(`in` rect: Vector2.Rect) -> Recipe {
    let populationInRect = population
      .filter { rect.contains($0.position) }
    
    let genomesInRect = populationInRect
      .reduce([Parameters]()) { (result, individual) -> [Parameters] in
        return result.filter { $0 == individual.genome }.isEmpty ? result + [individual.genome] : result
      }
      .map { genome -> Recipe.GenomeInfo in
        return Recipe.GenomeInfo.init(count: populationInRect.filter { $0.genome == genome }.count, area: nil, genome: genome)
    }
    
    let name = "Subset of \(recipe.name)"
    
    return Recipe.init(name: name, genomes: genomesInRect)
  }

  mutating func step(_ count: Int = 1) {
    guard count > 0 else {
      Log.error("Argument \"count\" should be a positive value")
      return
    }
    
    func getNeighbors(individual: Individual) -> [(distance: Value, individual: Individual)] {
      return population
        .map { neighbor -> (distance: Value, individual: Individual)? in
          guard neighbor !== individual else {
            return nil
          }
          let distance = individual.position.distance(neighbor.position)
          guard distance < individual.genome.neighborhoodRadius else {
            return nil
          }
          return (distance: distance, individual: neighbor)
        }
        .flatMap { $0 }
    }
    
    (0..<count).forEach { _ in
      population.forEach { individual in
        
        let genome = individual.genome
        let neighbors = getNeighbors(individual: individual)
        let acceleration: Vector2
        
        // Repulsive Force
        let x = individual.position.x
        let y = individual.position.y
        let repulsiveDistance: Value = Parameters.neighborhoodRadiusMax * 2.0
        
        let distanceFromBorderX = min(x, fieldSize.x - x) / repulsiveDistance
        let repulsiveX = distanceFromBorderX <= 1.0 ? pow(1.0 - distanceFromBorderX, 10.0) * individual.genome.maxVelocity : 0.0
        let directionX: Value = (x < fieldSize.x - x) ? 1 : -1
        
        let distanceFromBorderY = min(y, fieldSize.y - y) / repulsiveDistance
        let repulsiveY = distanceFromBorderY <= 1.0 ? pow(1.0 - distanceFromBorderY, 10.0) * individual.genome.maxVelocity : 0.0
        let directionY: Value = (y < fieldSize.y - y) ? 1 : -1
        
        let repulsiveForce = Vector2(repulsiveX * directionX, repulsiveY * directionY)

        if neighbors.count == 0 {
          acceleration = Vector2(1, 1).random() - Vector2(0.5, 0.5)
            + repulsiveForce
          
        } else {
          let numberOfNeighbors = Value(neighbors.count)
          
          // Center
          let sumCenter = neighbors.reduce(Vector2.zero) { (result, value) -> Vector2 in
            return result + value.individual.position
          }
          let averageCenter = sumCenter / numberOfNeighbors
          
          // Velocity
          let sumVelocity = neighbors.reduce(Vector2.zero) { (result, value) -> Vector2 in
            return result + value.individual.velocity
          }
          let averageVelocity = sumVelocity / numberOfNeighbors

          // Separation
          let sumSeparation = neighbors.reduce(Vector2.zero) { (result, value) -> Vector2 in
            return result
              + (individual.position - value.individual.position)
              / max(value.distance * value.distance, 0.001)
              * genome.separatingForce
          }
          
          // Steering
          let steering: Vector2
          if Double(arc4random() % 100) < (genome.probabilityOfRandomSteering * 100.0) {
            steering = Vector2(Value(arc4random() % 10) - 4.5, Value(arc4random() % 10) - 4.5)
          } else {
            steering = .zero
          }
          
          acceleration = (averageCenter - individual.position) * genome.cohesiveForce
            + (averageVelocity - individual.velocity) * genome.aligningForce
            + sumSeparation
            + steering
            + repulsiveForce
        }
        
        individual.accelerate(acceleration)
        
        let d = max(individual.acceleration.size(), 0.001)
        individual.accelerate(individual.acceleration * (genome.normalSpeed - d) / d * genome.tendencyOfPacekeeping)
        
        individual.move(in: self.fieldSize)
      }
    }
    steps += count
  }
}

// MARK: - CustomStringConvertible
extension Population: CustomStringConvertible {
  public var description: String {
    return recipe.genomes
      .map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
  }
}
