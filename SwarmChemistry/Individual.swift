//
//  Individual.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Individual
public class Individual {
  public fileprivate(set) var position: Vector2
  public fileprivate(set) var velocity = Vector2.zero
  public fileprivate(set) var acceleration = Vector2.zero
  public let genome: Parameters

  public init(position: Vector2, genome: Parameters) {
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
  func accelerate(_ acceleration: Vector2) {
    self.acceleration = self.acceleration + acceleration  // swiftlint:disable:this shorthand_operator

    let accelerationSize = self.acceleration.x * self.acceleration.x + self.acceleration.y * self.acceleration.y
    if accelerationSize > genome.maxVelocity {
      self.acceleration = self.acceleration * (genome.maxSpeed / sqrt(accelerationSize))
    }
  }

  func move(`in` fieldSize: Vector2) {
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
