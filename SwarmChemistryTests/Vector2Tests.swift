//
//  Vector2Tests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class Vector2Tests: XCTestCase {
  
  func test_zero() {
    let zero = Vector2.zero
    
    XCTAssert(zero == Vector2(0, 0))
  }
  
  func test_init() {
    XCTAssert(Vector2(12.0, 12.0) == Vector2(12, 12))
  }
  
  func test_size() {
    XCTAssert(Vector2(3, 4).size() == 5.0)
    XCTAssert(Vector2(-3, -4).size() == 5.0)
    XCTAssert(Vector2.zero.size() == 0.0)
  }
  
  func test_random() {
    let vector = Vector2(10.0, 10.0)
    
    (0..<100).forEach { _ in
      XCTAssert(vector.contains(vector.random()))
    }
  }
  
  func test_rect() {
    let vector = Vector2(12, 34)
    let rect = vector.rect
    
    XCTAssert(rect.origin == .zero)
    XCTAssert(rect.size == vector)
  }
  
  func test_distance() {
    let zero = Vector2.zero
    
    XCTAssert(zero.distance(Vector2(3, 4)) == 5)
    XCTAssert(zero.distance(Vector2(-3, -4)) == 5)
    XCTAssert(zero.distance(.zero) == 0.0)
  }
  
  func test_fit() {
    let positive = Vector2(105, 105)
    
    XCTAssert(positive.fit(to: Vector2(100, 100)) == Vector2(5, 5))
    XCTAssert(positive.fit(to: Vector2(10, 10)) == Vector2(5, 5))
    XCTAssert(positive.fit(to: Vector2(200, 200)) == positive)
    
    let negative = Vector2(-5, -5)
    XCTAssert(negative.fit(to: Vector2(100, 100)) == Vector2(95, 95))
    XCTAssert(negative.fit(to: Vector2(10, 10)) == Vector2(5, 5))
  }
  
  func test_operators() {
    let vector = Vector2(1, 2)
    
    XCTAssert(vector + Vector2(-1, -2) == .zero)
    XCTAssert(vector - vector == .zero)
    XCTAssert(vector * 2 == Vector2(2, 4))
    XCTAssert(vector / 2 == Vector2(0.5, 1))
  }
  
  func test_equality() {
    let vector = Vector2(1.1, 2.2)
    
    XCTAssert(vector == Vector2(1.1, 2.2))
    XCTAssert(vector != Vector2(1.0, 2.2))
    XCTAssert(vector != Vector2(1.1, 2.0))
  }
  
  func test_description() {
    XCTAssert(Vector2(1, 2).description == "(1.00, 2.00)")
    XCTAssert(Vector2(1.001, 2.001).description == "(1.00, 2.00)")
  }
  
  func test_contains() {
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(10.0, 10.0)))
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(10.0, 5.0)))
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(5.0, 10.0)))
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(5.0, 5.0)))
    
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(20.0, 20.0)) == false)
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(20.0, 10.0)) == false)
    XCTAssert(Vector2(10.0, 10.0).contains(Vector2(10.0, 20.0)) == false)
  }
}

class Vector2RectTests: XCTestCase {
  
  func test_init() {
    let rectWithValue = Vector2.Rect.init(x: 1.0, y: 2.0, width: 10.0, height: 20.0)
    
    XCTAssert(rectWithValue.origin.x == 1.0)
    XCTAssert(rectWithValue.origin.y == 2.0)
    XCTAssert(rectWithValue.size.x == 10.0)
    XCTAssert(rectWithValue.size.y == 20.0)
    
    let rectWithInt = Vector2.Rect.init(x: 1, y: 2, width: 10, height: 20)
    
    XCTAssert(rectWithInt.origin.x == 1.0)
    XCTAssert(rectWithInt.origin.y == 2.0)
    XCTAssert(rectWithInt.size.x == 10.0)
    XCTAssert(rectWithInt.size.y == 20.0)
    
    XCTAssert(rectWithValue == rectWithInt)
  }
  
  func test_zero() {
    XCTAssert(Vector2.Rect.zero == Vector2.Rect.init(x: 0, y: 0, width: 0, height: 0))
  }
  
  func test_random() {
    let rect = Vector2.Rect.init(x: 100, y: 100, width: 100, height: 100)
    
    (0..<100).forEach { _ in
      XCTAssert(rect.contains(rect.random()))
    }
  }
  
  func test_contains() {
    let rect = Vector2.Rect.init(origin: .init(10, 10), size: .init(5, 5))
    
    XCTAssert(rect.contains(.init(9, 9)) == false)
    XCTAssert(rect.contains(.init(9, 10)) == false)
    XCTAssert(rect.contains(.init(10, 9)) == false)
    XCTAssert(rect.contains(.init(15, 16)) == false)
    XCTAssert(rect.contains(.init(16, 15)) == false)
    XCTAssert(rect.contains(.init(16, 16)) == false)
    
    XCTAssert(rect.contains(.init(10, 10)) == true)
    XCTAssert(rect.contains(.init(12, 12)) == true)
    XCTAssert(rect.contains(.init(15, 15)) == true)
  }
  
  func test_operators() {
    let rect = Vector2.Rect.init(x: 1, y: 2, width: 3, height: 4)
    
    XCTAssert(rect + Vector2.Rect.init(x: -1, y: -2, width: -3, height: -4) == .zero)
    XCTAssert(rect - rect == .zero)
    XCTAssert(rect * 2.0 == .init(x: 2, y: 4, width: 6, height: 8))
    XCTAssert(rect / 2.0 == .init(x: 0.5, y: 1.0, width: 1.5, height: 2.0))
  }
  
  func test_equality() {
    let rect = Vector2.Rect.init(x: 1.1, y: 2.2, width: 3.3, height: 4.4)
    
    XCTAssert(rect == Vector2.Rect.init(x: 1.1, y: 2.2, width: 3.3, height: 4.4))
    XCTAssert(rect != Vector2.Rect.init(x: 1.0, y: 2.2, width: 3.3, height: 4.4))
    XCTAssert(rect != Vector2.Rect.init(x: 1.1, y: 2.0, width: 3.3, height: 4.4))
    XCTAssert(rect != Vector2.Rect.init(x: 1.1, y: 2.2, width: 3.0, height: 4.4))
    XCTAssert(rect != Vector2.Rect.init(x: 1.1, y: 2.2, width: 3.3, height: 4.0))
  }
  
  func test_description() {
    let expectedDescription = "((x: 1.00, y: 2.00), (width: 3.00, height: 4.00))"
    
    let description1 = Vector2.Rect.init(x: 1, y: 2, width: 3, height: 4).description
    XCTAssert(description1 == expectedDescription)
    
    let description2 = Vector2.Rect.init(x: 1.001, y: 2.001, width: 3.001, height: 4.001).description
    XCTAssert(description2 == expectedDescription)
  }
}
