//
//  Coordinate.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public struct Coordinate {
  
  public let x: Value
  public let y: Value
  //  let z: Double // TODO: make it 3D
}

extension Coordinate {
  static let zero = Coordinate(0.0, 0.0)
  
  func distance(_ other: Coordinate) -> Value {
    return max(hypot(x - other.x, y - other.y), 0.0001)
  }
}

extension Coordinate {
  public init(_ x: Value, _ y: Value) {
    self.x = x
    self.y = y
  }
}

extension Coordinate {
  static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
    return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
  }
  
  static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
    return Coordinate(lhs.x - rhs.x, lhs.y - rhs.y)
  }
  
  static func *(coordinate: Coordinate, multiplier: Value) -> Coordinate {
    return Coordinate(coordinate.x * multiplier, coordinate.y * multiplier)
  }
  
  static func /(coordinate: Coordinate, divider: Value) -> Coordinate {
    return Coordinate(coordinate.x / divider, coordinate.y / divider)
  }
}

extension Coordinate: CustomStringConvertible {
  public var description: String {
    return "(\(x), \(y))"
  }
}
