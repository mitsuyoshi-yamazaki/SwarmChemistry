//
//  CoordinateTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class CoordinateTests: XCTestCase {

  func test_zero() {
    let zero = Coordinate.zero
    
    XCTAssert(zero == Coordinate(0, 0))
  }
  
  func test_init() {
    XCTAssert(Coordinate(12.0, 12.0) == Coordinate(12, 12))
  }
  
  func test_distance() {
    let zero = Coordinate.zero
    
    XCTAssert(zero.distance(Coordinate(3, 4)) == 5)
    XCTAssert(zero.distance(Coordinate(-3, -4)) == 5)
    XCTAssert(zero.distance(Coordinate(00001, 0)) == 0001)
  }
  
  func test_fit() {
    let positive = Coordinate(105, 105)
    
    XCTAssert(positive.fit(to: Coordinate(100, 100)) == Coordinate(5, 5))
    XCTAssert(positive.fit(to: Coordinate(10, 10)) == Coordinate(5, 5))
    XCTAssert(positive.fit(to: Coordinate(200, 200)) == positive)
    
    let negative = Coordinate(-5, -5)
    XCTAssert(negative.fit(to: Coordinate(100, 100)) == Coordinate(95, 95))
    XCTAssert(negative.fit(to: Coordinate(10, 10)) == Coordinate(5, 5))
  }
  
  func test_equality() {
    XCTAssert(Coordinate(3.2, 1.0) == Coordinate(3.2, 1.0))
    XCTAssert(Coordinate(3.2, 1.0) != Coordinate(3.2, 1.1))
  }
  
  func test_random() {
    let coordinate = Coordinate(10.0, 10.0)
    
    (0..<100).forEach { _ in
      XCTAssert(coordinate.contains(coordinate.random()))
    }
  }
  
  func test_contains() {
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(10.0, 10.0)))
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(10.0, 5.0)))
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(5.0, 10.0)))
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(5.0, 5.0)))
    
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(20.0, 20.0)) == false)
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(20.0, 10.0)) == false)
    XCTAssert(Coordinate(10.0, 10.0).contains(Coordinate(10.0, 20.0)) == false)
  }
}
