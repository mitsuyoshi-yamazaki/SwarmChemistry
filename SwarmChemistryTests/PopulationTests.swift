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
  
  func test_uniqueGenomes() {
    let genomeCount = 5
    let numberOfEachGenomes = 10
    let indivisuals: [Individual] = (0..<genomeCount)
      .map { _ in Parameters.random }
      .map { genome in
        (0..<numberOfEachGenomes).map { _ in Individual(genome: genome) }
      }
      .flatMap { $0 }
    
    let population = Population(fieldSize: .zero, population: indivisuals)
    let result = population.uniqueGenomes()
    let counts = result.map { $0.count }
    let numberOfMismatch = counts.filter { $0 != numberOfEachGenomes }.count
    
    XCTAssert(numberOfMismatch == 0, "counts: \(counts)")
  }
}
