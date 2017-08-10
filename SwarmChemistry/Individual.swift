//
//  Individual.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Individual
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

// MARK: - Convenience initializer
public extension Individual {
  convenience init(genome: Parameters) {
    self.init(position: .zero, genome: genome)
  }
}

// MARK: - Function
extension Individual {
  func accelerate(_ acceleration: Coordinate) {
    self.acceleration = self.acceleration + acceleration

    let magunitude = hypot(self.acceleration.x, self.acceleration.y)
    if magunitude > genome.maxVelocity {
      self.acceleration = self.acceleration * (genome.maxVelocity / magunitude)
    }
  }
  
  func move(`in` fieldSize: Coordinate) {
    velocity = acceleration
    position = (position + velocity).fit(to: fieldSize)
  }
}

// MARK: - CustomStringConvertible
extension Individual: CustomStringConvertible {
  public var description: String {
    return "(\(String(describing: type(of: self))) position: \(position), genome: \(genome))"
  }
}
