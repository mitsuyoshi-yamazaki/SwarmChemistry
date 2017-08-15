//
//  PopulationTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class PopulationTests: XCTestCase {
  
  func test_init() {
    // Tests init won't fail
    let _ = Population.init(.jellyFish)
    let _ = Population.init(.none())
    let _ = Population.init(.random(numberOfGenomes: 10))
  }
}
