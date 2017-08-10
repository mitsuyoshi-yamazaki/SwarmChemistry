//
//  Population.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public struct Population {
  public let fieldSize: Coordinate
  public let population: [Individual]
  
  public init(fieldSize: Coordinate, population: [Individual]) {
    self.fieldSize = fieldSize
    self.population = population
  }
}

extension Population {
  public func uniqueGenomes() -> [(genome: Parameters, count: Int)] {
    // Could we make it O(n) ?
    return population
      .reduce([Parameters]()) { (result, individual) -> [Parameters] in
        return result.filter { $0 == individual.genome }.isEmpty ? result + [individual.genome] : result
      }
      .map { genome -> (genome: Parameters, count: Int) in
        return (genome: genome, count: self.population.filter { $0.genome == genome }.count)
      }
  }
  
  public func step(_ count: Int = 1) {
    guard count > 0 else {
      Log.error("Argument \"count\" should be a positive value")
      return
    }
    
    (0..<count).forEach { _ in
      population.forEach { individual in
        
        let distances = population
          .map { neighbor -> (distance: Value, individual: Individual)? in
            let distance = individual.position.distance(neighbor.position)
            guard distance < individual.genome.neighborhoodRadius else {
              return nil
            }
            return (distance: distance, individual: neighbor)
          }
          .flatMap { $0 }
        
        if distances.count == 0 {
          Log.debug("No nearby neighbors")
          // TODO:
        }
        
        let numberOfNeighbors = Value(distances.count)
        
        // Center
        let sumCenter = distances.reduce(Coordinate.zero) { (result, value) -> Coordinate in
          return result + value.individual.position
        }
        let averageCenter = sumCenter / numberOfNeighbors
        
        // Velocity
        let sumVelocity = distances.reduce(Coordinate.zero) { (result, value) -> Coordinate in
          return result + value.individual.velocity
        }
        let averageVelocity = sumVelocity / numberOfNeighbors
        
        // Separation
        let sumSeparation = distances.reduce(Coordinate.zero) { (result, value) -> Coordinate in
          let divider = value.distance * individual.genome.separatingForce
          return result + (individual.position - value.individual.position) / divider
        }
        
        // Steering
        let steering: Coordinate
        if Double(arc4random() % 100) < (individual.genome.probabilityOfRandomSteering * 100.0) {
          steering = Coordinate(Double(arc4random() % 4) - 1.5, Double(arc4random() % 4) - 1.5)
        } else {
          steering = .zero
        }
        
        let acceleration = (averageCenter - individual.position) * individual.genome.cohesiveForce
          + (averageVelocity - individual.velocity) * individual.genome.aligningForce
          + sumSeparation
          + steering
        
        individual.accelerate(acceleration)
        
        let distance = Swift.max(hypot(individual.acceleration.x, individual.acceleration.y), 0.0001)
        let accelerateMultiplier = (individual.genome.normalSpeed - distance) / distance * individual.genome.tendencyOfPacekeeping
        
        individual.accelerate(individual.acceleration * accelerateMultiplier)
        
        individual.move(in: self.fieldSize)
      }
    }
  }
}

extension Population: CustomStringConvertible {
  // po print(self.description)
  public var description: String {
    return uniqueGenomes()
      .map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
  }
}
