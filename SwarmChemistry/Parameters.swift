//
//  Agent.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public struct Parameters {
  
  let neighborhoodRadius: Value
  static let neighborhoodRadiusMax = 300.0
  
  let normalSpeed: Value
  static let normalSpeedMax = 20.0
  
  let maxSpeed: Value
  static let maxSpeedMax = 40.0
  
  let cohesiveForce: Value
  static let cohesiveForceMax = 1.0
  
  let aligningForce: Value
  static let aligningForceMax = 1.0
  
  let separatingForce: Value
  static let separatingForceMax = 100.0
  
  let probabilityOfRandomSteering: Value
  static let probabilityOfRandomSteeringMax = 0.5
  
  let tendencyOfPacekeeping: Value
  static let tendencyOfPacekeepingMax = 1.0
  
  let maxVelocity: Value
  
  public init(neighborhoodRadius: Value, normalSpeed: Value, maxSpeed: Value, cohesiveForce: Value, aligningForce: Value, separatingForce: Value, probabilityOfRandomSteering: Value, tendencyOfPacekeeping: Value) {
    
    self.neighborhoodRadius = neighborhoodRadius
    self.normalSpeed = normalSpeed
    self.maxSpeed = maxSpeed
    self.cohesiveForce = cohesiveForce
    self.aligningForce = aligningForce
    self.separatingForce = separatingForce
    self.probabilityOfRandomSteering = probabilityOfRandomSteering
    self.tendencyOfPacekeeping = tendencyOfPacekeeping
    
    maxVelocity = maxSpeed * maxSpeed
  }
}

extension Parameters {
  var all: [Value] {
    return [
      neighborhoodRadius,
      normalSpeed,
      maxSpeed,
      cohesiveForce,
      aligningForce,
      separatingForce,
      probabilityOfRandomSteering,
      tendencyOfPacekeeping
    ]
  }
}

extension Parameters {
  private static let numberOfParameters = 8
  
  public init?(_ parameters: [Value]) {
    guard parameters.count == type(of: self).numberOfParameters else {
      return nil
    }
    
    // should validate each values?
    neighborhoodRadius          = parameters[0]
    normalSpeed                 = parameters[1]
    maxSpeed                    = parameters[2]
    cohesiveForce               = parameters[3]
    aligningForce               = parameters[4]
    separatingForce             = parameters[5]
    probabilityOfRandomSteering = parameters[6]
    tendencyOfPacekeeping       = parameters[7]
    
    maxVelocity = maxSpeed * maxSpeed
  }
}

extension Parameters: CustomStringConvertible {
  public var description: String {
    let values = all.map { String.init(format: "%.2f", $0) }.joined(separator: ", ")
    return "(\(values))"
  }
}
