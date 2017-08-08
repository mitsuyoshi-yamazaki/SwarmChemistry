//
//  Individual.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public class Individual {
  
  fileprivate(set) public var position: Coordinate
  fileprivate(set) public var velocity = Coordinate.zero
  fileprivate(set) public var acceleration = Coordinate.zero
  public let genome: Parameters

  public init(position: Coordinate, genome: Parameters) {
    self.position = position
    self.genome = genome
  }
}

extension Individual {
  public convenience init(genome: Parameters) {
    self.init(position: .zero, genome: genome)
  }
}

extension Individual {
  func accelerate(_ acceleration: Coordinate) {
    self.acceleration = self.acceleration + acceleration

    let magunitude = hypot(acceleration.x, acceleration.y)
    if magunitude > genome.maxVelocity {
      self.acceleration = self.acceleration * (genome.maxVelocity / magunitude)
    }
  }
  
  func move() {
    velocity = acceleration
    position = position + velocity
  }
}

extension Individual: CustomStringConvertible {
  public var description: String {
    return "(\(String(describing: type(of: self))) position: \(position), genome: \(genome))"
  }
}

extension Array where Element == Individual {
  public func step(_ count: Int = 1) {
    guard count > 0 else {
      Log.error("Argument \"count\" should be positive value")
      return
    }
    
    (0..<count).forEach { _ in
      forEach { individual in
        
        let distances = self
          .map { neighbor -> (distance: Value, individual: Individual)? in
            let distance = individual.position.distance(neighbor.position)
            guard distance < individual.genome.neighborhoodRadius else {
              return nil
            }
            return (distance: distance, individual: neighbor)
          }
          .flatMap { $0 }
        
        if distances.count == 0 {
          Log.debug("no nearby neighbors")
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
          let divider = value.distance / individual.genome.separatingForce
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
        
        individual.move()
      }
    }
  }
}
