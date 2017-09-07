//
//  ParameterTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class ParametersTests: XCTestCase {

  func test_init() {
    let values = [ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0 ]
    let parameters = Parameters(values)!
    
    XCTAssert(parameters.neighborhoodRadius == 1.0)
    XCTAssert(parameters.normalSpeed == 2.0)
    XCTAssert(parameters.maxSpeed == 3.0)
    XCTAssert(parameters.cohesiveForce == 4.0)
    XCTAssert(parameters.aligningForce == 5.0)
    XCTAssert(parameters.separatingForce == 6.0)
    XCTAssert(parameters.probabilityOfRandomSteering == 7.0)
    XCTAssert(parameters.tendencyOfPacekeeping == 8.0)
    XCTAssert(parameters.maxVelocity == 9.0)
  }
  
  func test_all() {
    let values = [ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0 ]
    let parameters = Parameters(values)!
    
    XCTAssert(parameters.all == values)
  }
  
  func test_equality() {
    let values = [ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0 ]
    let anotherValues = [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ]

    XCTAssert(Parameters(values)! == Parameters(values)!)
    XCTAssert(Parameters(values)! != Parameters(anotherValues)!)
  }
  
  func test_zero() {
    let parameters = Parameters.zero

    XCTAssert(parameters.neighborhoodRadius == 0.0)
    XCTAssert(parameters.normalSpeed == 0.0)
    XCTAssert(parameters.maxSpeed == 0.0)
    XCTAssert(parameters.cohesiveForce == 0.0)
    XCTAssert(parameters.aligningForce == 0.0)
    XCTAssert(parameters.separatingForce == 0.0)
    XCTAssert(parameters.probabilityOfRandomSteering == 0.0)
    XCTAssert(parameters.tendencyOfPacekeeping == 0.0)
    XCTAssert(parameters.maxVelocity == 0.0)
  }
  
  func test_random() {
    XCTAssert(Parameters.random != Parameters.random)
  }
}
