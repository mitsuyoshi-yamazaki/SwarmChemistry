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

public extension Coordinate {
  static let zero = Coordinate(0.0, 0.0)
  
  func distance(_ other: Coordinate) -> Value {
    return max(hypot(x - other.x, y - other.y), 0.0001) // TODO: consider if 0.0001 literal needed
  }
  
  func fit(to coordinate: Coordinate) -> Coordinate {
    let x: Value
    if self.x > coordinate.x {
      x = self.x - (floor(self.x / coordinate.x) * coordinate.x)
    } else if self.x < 0.0 {
      x = self.x + (floor((-self.x + coordinate.x) / coordinate.x) * coordinate.x)
    } else {
      x = self.x
    }

    let y: Value
    if self.y > coordinate.y {
      y = self.y - (floor(self.y / coordinate.y) * coordinate.y)
    } else if self.y < 0.0 {
      y = self.y + (floor((-self.y + coordinate.y) / coordinate.y) * coordinate.y)
    } else {
      y = self.y
    }

    return Coordinate(x, y)
  }
  
  func random() -> Coordinate {
    let x = self.x * (Value(Int(arc4random() % 100)) / 100.0)
    let y = self.y * (Value(Int(arc4random() % 100)) / 100.0)

    return Coordinate(x, y)
  }
  
  func contains(_ other: Coordinate) -> Bool {
    return (x >= other.x) && (y >= other.y)
  }
}

public extension Coordinate {
  public init(_ x: Value, _ y: Value) {
    self.x = x
    self.y = y
  }
  
  public init(_ x: Int, _ y: Int) {
    self.x = Value(x)
    self.y = Value(y)
  }
}

public extension Coordinate {
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

extension Coordinate: Equatable {
  public static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
  }
}
