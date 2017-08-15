//
//  Vector2Tests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
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
  
  func test_equality() {
    XCTAssert(Vector2(3.2, 1.0) == Vector2(3.2, 1.0))
    XCTAssert(Vector2(3.2, 1.0) != Vector2(3.2, 1.1))
  }
  
  func test_random() {
    let vector = Vector2(10.0, 10.0)
    
    (0..<100).forEach { _ in
      XCTAssert(vector.contains(vector.random()))
    }
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
}
