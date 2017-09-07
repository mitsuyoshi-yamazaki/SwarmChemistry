//
//  Vector2.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
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

// MARK: - Accessor
public extension Vector2 {
  static let zero = Vector2(0.0, 0.0)
  
  func size() -> Value {
    return hypot(x, y)
  }
 
  func random() -> Vector2 {
    let x = self.x * (Value(Int(arc4random() % 100)) / 100.0)
    let y = self.y * (Value(Int(arc4random() % 100)) / 100.0)
    
    return Vector2(x, y)
  }
  
  var rect: Vector2.Rect {
    return Vector2.Rect.init(origin: .zero, size: self)
  }
}

// MARK: - Function
public extension Vector2 {
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
    return String.init(format: "(%.2f, %.2f)", x, y)
  }
}

// MARK: - Equatable
extension Vector2: Equatable {
  public static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
  }
}

// MARK: - Rect
public extension Vector2 {
  struct Rect {
    let origin: Vector2
    let size: Vector2
    
    public init(origin: Vector2, size: Vector2) {
      self.origin = origin
      self.size = size
    }
  }
}

// MARK: - Convenience initializer
public extension Vector2.Rect {
  init(x: Value, y: Value, width: Value, height: Value) {
    self.init(origin: .init(x, y), size: .init(width, height))
  }
  
  init(x: Int, y: Int, width: Int, height: Int) {
    self.init(origin: .init(x, y), size: .init(width, height))
  }
}

// MARK: - Accessor
public extension Vector2.Rect {
  static let zero = Vector2.Rect.init(x: 0, y: 0, width: 0, height: 0)
  
  func random(unit: Int = 1) -> Vector2.Rect {
    // TODO: Need validation
    return Vector2.Rect.init(origin: random(), size: random())
  }
  
  func random() -> Vector2 {
    let x = size.x * (Value(Int(arc4random() % 100)) / 100.0) + origin.x
    let y = size.y * (Value(Int(arc4random() % 100)) / 100.0) + origin.y
    
    return Vector2(x, y)
  }
}

// MARK: - Function
public extension Vector2.Rect {
  func contains(_ point: Vector2) -> Bool {
    guard (point.x >= origin.x) && (point.x <= origin.x + size.x) else {
      return false
    }
    guard (point.y >= origin.y) && (point.y <= origin.y + size.y) else {
      return false
    }
    return true
  }
}

// MARK: - Operator override
public extension Vector2.Rect {
  static func +(lhs: Vector2.Rect, rhs: Vector2.Rect) -> Vector2.Rect {
    return .init(origin: lhs.origin + rhs.origin, size: lhs.size + rhs.size)
  }
  
  static func -(lhs: Vector2.Rect, rhs: Vector2.Rect) -> Vector2.Rect {
    return .init(origin: lhs.origin - rhs.origin, size: lhs.size - rhs.size)
  }
  
  static func *(rect: Vector2.Rect, multiplier: Value) -> Vector2.Rect {
    return .init(origin: rect.origin * multiplier, size: rect.size * multiplier)
  }
  
  static func /(rect: Vector2.Rect, divider: Value) -> Vector2.Rect {
    return .init(origin: rect.origin / divider, size: rect.size / divider)
  }
}

// MARK: - Equatable
extension Vector2.Rect: Equatable {
  public static func ==(lhs: Vector2.Rect, rhs: Vector2.Rect) -> Bool {
    return (lhs.origin == rhs.origin) && (lhs.size == rhs.size)
  }
}

// MARK: - CustomStringConvertible
extension Vector2.Rect: CustomStringConvertible {
  public var description: String {
    return String.init(format: "((x: %.2f, y: %.2f), (width: %.2f, height: %.2f))", origin.x, origin.y, size.x, size.y)
  }
}
