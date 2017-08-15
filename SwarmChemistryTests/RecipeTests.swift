//
//  RecipeTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/15.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class RecipeTests: XCTestCase {
  
  func test_none() {
    XCTAssert(Recipe.none().genomes.isEmpty)
  }
}
