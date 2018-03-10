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
  public enum Polarity {
    case positive(force: Value)
    case neutral
    case negative(force: Value)
    
    func getForces() -> (positiveForce: Value, negativeForce: Value) {
      switch self {
      case .positive(let force):
        return (force, 0.0)
      
      case .neutral:
        return (0.0, 0.0)

      case .negative(let force):
        return (0.0, force)
      }
    }
    
    init(positiveForce: Value, negativeForce: Value) {
      switch (positiveForce, negativeForce) {
      case _ where (positiveForce > 0.0 && negativeForce == 0.0):
        self = .positive(force: positiveForce)
        
      case _ where (positiveForce == 0.0 && negativeForce > 0.0):
        self = .negative(force: negativeForce)
        
      default:
        self = .neutral
      }
    }
  }
  
  public let nuclearForce: Value
  public static let nuclearForceRange = Range<Value>.init(minimum: 1.0, maximum: 10.0)
  
  public let polarityForce: Polarity
  public static let polarityForceRange = Range<Value>.init(minimum: 1.0, maximum: 100.0)
  
  public let color: Color
  
  init(nuclearForce: Value, polarityForce: Polarity) {
    self.nuclearForce = nuclearForce
    self.polarityForce = polarityForce
    
    let (positiveForce, negativeForce) = polarityForce.getForces()
    
    let red = CGFloat((1.0 - (negativeForce / type(of: self).polarityForceRange.maximum)) * 0.8)
    let green = CGFloat((nuclearForce / type(of: self).nuclearForceRange.maximum) * 0.8)
    let blue = CGFloat((1.0 - (positiveForce / type(of: self).polarityForceRange.maximum)) * 0.8)
    color = Color.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

// MARK: Convenience initializer
public extension Parameters {
  internal static let numberOfParameters = 3
  
  init?(_ parameters: [Value]) {
    guard parameters.count == type(of: self).numberOfParameters else {
      return nil
    }
    
    // should validate each values?
    nuclearForce = parameters[0]
    polarityForce = Polarity.init(positiveForce: parameters[1], negativeForce: parameters[2])
    
    let (positiveForce, negativeForce) = polarityForce.getForces()

    let red = CGFloat((1.0 - (negativeForce / type(of: self).polarityForceRange.maximum)) * 0.8)
    let green = CGFloat((nuclearForce / type(of: self).nuclearForceRange.maximum) * 0.8)
    let blue = CGFloat((1.0 - (positiveForce / type(of: self).polarityForceRange.maximum)) * 0.8)
    color = Color.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

// MARK: - Accessor
public extension Parameters {
  var all: [Value] {
    let (positiveForce, negativeForce) = polarityForce.getForces()

    return [
      nuclearForce,
      positiveForce,
      negativeForce
    ]
  }
  
  static var maxValues: [Value] {
    return [
      nuclearForceRange.maximum,
      polarityForceRange.maximum,
      polarityForceRange.maximum
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
