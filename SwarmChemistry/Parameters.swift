//
//  Agent.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Parameters
public struct Parameters {
  
  public let neighborhoodRadius: Value
  public static let neighborhoodRadiusMax = 300.0
  
  public let normalSpeed: Value
  public static let normalSpeedMax = 20.0
  
  public let maxSpeed: Value
  public static let maxSpeedMax = 40.0
  
  public let cohesiveForce: Value // c1
  public static let cohesiveForceMax = 1.0
  
  public let aligningForce: Value // c2
  public static let aligningForceMax = 1.0
  
  public let separatingForce: Value // c3
  public static let separatingForceMax = 100.0
  
  public let probabilityOfRandomSteering: Value // c4
  public static let probabilityOfRandomSteeringMax = 0.5
  
  public let tendencyOfPacekeeping: Value // c5
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

// MARK: Convenience initializer
public extension Parameters {
  internal static let numberOfParameters = 8
  
  init?(_ parameters: [Value]) {
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

// MARK: - Accessor
public extension Parameters {
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
  
  static var maxValues: [Value] {
    return [
      neighborhoodRadiusMax,
      normalSpeedMax,
      maxSpeedMax,
      cohesiveForceMax,
      aligningForceMax,
      separatingForceMax,
      probabilityOfRandomSteeringMax,
      tendencyOfPacekeepingMax
    ]
  }
  
  static var zero: Parameters {
    return Parameters((0..<numberOfParameters).map { _ in 0.0 })!
  }
  
  static var random: Parameters {
    let values = maxValues
      .map { Value(Int(arc4random()) % Int($0 * 100)) / 100.0 }
    
    return Parameters(values)!
  }
}

// MARK: - CustomStringConvertible
extension Parameters: CustomStringConvertible {
  public var description: String {
    let values = all.map { String.init(format: "%.2f", $0) }.joined(separator: ", ")
    return "(\(values))"
  }
}

// MARK: - Equatable
extension Parameters: Equatable {
  public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
    return lhs.all == rhs.all
  }
}
