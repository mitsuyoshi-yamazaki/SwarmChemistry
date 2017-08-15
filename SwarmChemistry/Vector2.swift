//
//  Vector2.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Vector2
public struct Vector2 {
  
  public let x: Value
  public let y: Value
}

// MARK: - Convenience initializer
public extension Vector2 {
  public init(_ x: Value, _ y: Value) {
    self.x = x
    self.y = y
  }
  
  public init(_ x: Int, _ y: Int) {
    self.x = Value(x)
    self.y = Value(y)
  }
}

// MARK: - Function
public extension Vector2 {
  static let zero = Vector2(0.0, 0.0)
  
  func size() -> Value {
    return hypot(x, y)
  }
  
  func distance(_ other: Vector2) -> Value {
    return hypot(x - other.x, y - other.y)
  }
  
  func fit(to size: Vector2) -> Vector2 {
    let x: Value
    if self.x > size.x {
      x = self.x - (floor(self.x / size.x) * size.x)
    } else if self.x < 0.0 {
      x = self.x + (floor((-self.x + size.x) / size.x) * size.x)
    } else {
      x = self.x
    }

    let y: Value
    if self.y > size.y {
      y = self.y - (floor(self.y / size.y) * size.y)
    } else if self.y < 0.0 {
      y = self.y + (floor((-self.y + size.y) / size.y) * size.y)
    } else {
      y = self.y
    }

    return Vector2(x, y)
  }
  
  func random() -> Vector2 {
    let x = self.x * (Value(Int(arc4random() % 100)) / 100.0)
    let y = self.y * (Value(Int(arc4random() % 100)) / 100.0)

    return Vector2(x, y)
  }
  
  func contains(_ other: Vector2) -> Bool {
    return (x >= other.x) && (y >= other.y)
  }
}

// MARK: - Operator override
public extension Vector2 {
  static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
    return Vector2(lhs.x + rhs.x, lhs.y + rhs.y)
  }
  
  static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
    return Vector2(lhs.x - rhs.x, lhs.y - rhs.y)
  }
  
  static func *(vector: Vector2, multiplier: Value) -> Vector2 {
    return Vector2(vector.x * multiplier, vector.y * multiplier)
  }
  
  static func /(vector: Vector2, divider: Value) -> Vector2 {
    return Vector2(vector.x / divider, vector.y / divider)
  }
}

// MARK: - CustomStringConvertible
extension Vector2: CustomStringConvertible {
  public var description: String {
    return "(\(x), \(y))"
  }
}

// MARK: - Equatable
extension Vector2: Equatable {
  public static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
  }
}
