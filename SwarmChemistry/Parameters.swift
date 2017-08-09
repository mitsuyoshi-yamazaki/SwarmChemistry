//
//  Agent.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Parameters {
  
  public let neighborhoodRadius: Value
  public static let neighborhoodRadiusMax = 300.0
  
  public let normalSpeed: Value
  public static let normalSpeedMax = 20.0
  
  public let maxSpeed: Value
  public static let maxSpeedMax = 40.0
  
  public let cohesiveForce: Value
  public static let cohesiveForceMax = 1.0
  
  public let aligningForce: Value
  public static let aligningForceMax = 1.0
  
  public let separatingForce: Value
  public static let separatingForceMax = 100.0
  
  public let probabilityOfRandomSteering: Value
  public static let probabilityOfRandomSteeringMax = 0.5
  
  public let tendencyOfPacekeeping: Value
  public static let tendencyOfPacekeepingMax = 1.0
  
  public let maxVelocity: Value
  public let color: Color
  
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
    
    let red = CGFloat((cohesiveForce / type(of: self).cohesiveForceMax) * 0.8)
    let green = CGFloat((aligningForce / type(of: self).aligningForceMax) * 0.8)
    let blue = CGFloat((separatingForce / type(of: self).separatingForceMax) * 0.8)
    color = Color.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

extension Parameters {
  public var all: [Value] {
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

    let red = CGFloat((cohesiveForce / type(of: self).cohesiveForceMax) * 0.8)
    let green = CGFloat((aligningForce / type(of: self).aligningForceMax) * 0.8)
    let blue = CGFloat((separatingForce / type(of: self).separatingForceMax) * 0.8)
    color = Color.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

extension Parameters: CustomStringConvertible {
  public var description: String {
    let values = all.map { String.init(format: "%.2f", $0) }.joined(separator: ", ")
    return "(\(values))"
  }
}
