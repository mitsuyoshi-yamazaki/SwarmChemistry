//
//  Population.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Population
public struct Population {
  public var fieldSize = Vector2(500, 500)
  public let population: [Individual]
  public let recipe: Recipe
}

// MARK: - Recipe
public extension Population {
  init(_ recipe: Recipe, numberOfPopulation: Int? = nil, fieldSize: Vector2 = Vector2(500, 500)) {
    
    self.recipe = recipe
    
    let sum = recipe.genomes
      .reduce(0) { (result, value) -> Int in
        result + value.count
      }
    let magnitude = Value(numberOfPopulation ?? sum) / Value(sum)
    
    population = recipe.genomes
      .map { value -> [Individual] in
        let count = Int(Value(value.count) * magnitude)
        return (0..<count)
          .map { _ in
            Individual(position: fieldSize.random(), genome: value.genome)
          }
      }
      .flatMap { $0 }
    
    self.fieldSize = fieldSize
  }
}

// MARK: - Accessor
public extension Population {
  static func zero() -> Population {
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
        return (genome: genome, count: populationInRect.filter { $0.genome == genome }.count)
    }
    
    let name = "Subset of \(recipe.name)"
    
    return Recipe.init(name: name, genomes: genomesInRect)
  }

  func step(_ count: Int = 1) {
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
        
        if neighbors.count == 0 {
          acceleration = Vector2(1, 1).random() - Vector2(0.5, 0.5)
          
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
            steering = Vector2(Value(arc4random() % 10) - 5.0, Value(arc4random() % 10) - 5.0)
          } else {
            steering = .zero
          }
          
          acceleration = (averageCenter - individual.position) * genome.cohesiveForce
            + (averageVelocity - individual.velocity) * genome.aligningForce
            + sumSeparation
            + steering
        }
        
        individual.accelerate(acceleration)
        
        let d = max(individual.acceleration.size(), 0.001)
        individual.accelerate(individual.acceleration * (genome.normalSpeed - d) / d * genome.tendencyOfPacekeeping)
        
        individual.move(in: self.fieldSize)
      }
    }
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
