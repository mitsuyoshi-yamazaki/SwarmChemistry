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
  public var fieldSize = Coordinate(500, 500)
  public let population: [Individual]
  
  public init(fieldSize: Coordinate?, population: [Individual]) {
    self.population = population
    
    if let fieldSize = fieldSize {
      self.fieldSize = fieldSize
    }
  }
}

// MARK: - Recipe
public extension Population {
  /**
   Expecting:
   41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)
   26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)
   ...
   */
  init?(_ recipeText: String, numberOfPopulation: Int? = nil, fieldSize: Coordinate = Coordinate(500, 500)) {
    func parseLine(_ text: String) -> (count: Int, genomeText: String)? {
      let components = text
        .replacingOccurrences(of: " ", with: "")
        .components(separatedBy: "*")
      
      guard
        let count = Int(components.first ?? ""),
        let genomeText = components.dropFirst().first
      else {
        Log.debug("Parse line failed: \"\(text)\"")
        return nil
      }
      return (count: count, genomeText: genomeText)
    }
    func parseGenome(from text: String) -> Parameters? {
      let components = text
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .components(separatedBy: ",")
      
      guard let values = components.map({ Value($0) }) as? [Value] else {
        Log.debug("Parse genome parameters failed: \"\(text)\"")
        return nil
      }
      return Parameters(values)
    }
    
    let result = recipeText
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n")
      .map { line -> (count: Int, genomeText: String)? in
        parseLine(line)
      }
      .map { value -> (count: Int, genome: Parameters)? in
        guard let value = value else {
          return nil
        }
        guard let genome = parseGenome(from: value.genomeText) else {
          return nil
        }
        return (count: value.count, genome: genome)
      }
    
    guard let recipe = result as? [(count: Int, genome: Parameters)] else {
      Log.debug("Parsing recipe failed")
      return nil
    }
    
    let sum = recipe
      .reduce(0) { (result, value) -> Int in
        result + value.count
      }
    let magnitude = Value(numberOfPopulation ?? sum) / Value(sum)
    
    population = recipe
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
  
  func uniqueGenomes() -> [(genome: Parameters, count: Int)] {
    // Could we make it O(n) ?
    return population
      .reduce([Parameters]()) { (result, individual) -> [Parameters] in
        return result.filter { $0 == individual.genome }.isEmpty ? result + [individual.genome] : result
      }
      .map { genome -> (genome: Parameters, count: Int) in
        return (genome: genome, count: self.population.filter { $0.genome == genome }.count)
    }
  }

  func recipe() -> String {
    return uniqueGenomes()
      .map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
  }
}

// MARK: - Function
public extension Population {
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
        let acceleration: Coordinate
        
        if neighbors.count == 0 {
          acceleration = Coordinate(1, 1).random() - Coordinate(0.5, 0.5)
          
        } else {
          let numberOfNeighbors = Value(neighbors.count)
          
          // Center
          let sumCenter = neighbors.reduce(Coordinate.zero) { (result, value) -> Coordinate in
            return result + value.individual.position
          }
          let averageCenter = sumCenter / numberOfNeighbors
          
          // Velocity
          let sumVelocity = neighbors.reduce(Coordinate.zero) { (result, value) -> Coordinate in
            return result + value.individual.velocity
          }
          let averageVelocity = sumVelocity / numberOfNeighbors

          // Separation
          let sumSeparation = neighbors.reduce(Coordinate.zero) { (result, value) -> Coordinate in
            return result
              + (individual.position - value.individual.position)
              / max(value.distance * value.distance, 0.001)
              * genome.separatingForce
          }
          
          // Steering
          let steering: Coordinate
          if Double(arc4random() % 100) < (genome.probabilityOfRandomSteering * 100.0) {
            steering = Coordinate(Value(arc4random() % 10) - 5.0, Value(arc4random() % 10) - 5.0)
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
  // po print(self.description)
  public var description: String {
    return recipe()
  }
}
