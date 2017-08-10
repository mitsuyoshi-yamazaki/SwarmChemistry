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
  
  func test_recipe() {
    let recipeText = ""
      + "4 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)\n"
      + "2 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.90)\n"
      + "3 * (277.87, 15.02, 24.44, 0.68, 0.05, 82.96, 0.43, 0.90)\n"
      + "2 * (110.80, 16.12, 38.60, 0.18, 0.34, 14.30, 0.01, 0.01)\n"
      + "4 * (83.79, 13.29, 7.54, 0.08, 0.79, 1.07, 0.15, 0.45)\n"
      + "7 * (269.64, 6.62, 34.69, 0.36, 0.50, 30.20, 0.03, 0.23)\n"
    let withoutWhitespacesAndNewLines = recipeText.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let population = Population.init(recipeText)
    XCTAssert(population != nil)
    
    // It fails if recipeText's values were rounded or the order was changed
    XCTAssert(population!.recipe() == withoutWhitespacesAndNewLines)
  }
  
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
