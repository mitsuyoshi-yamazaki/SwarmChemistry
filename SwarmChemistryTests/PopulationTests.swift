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
  
  func test_zero() {
    let zero = Population.zero()
    
    XCTAssert(zero.fieldSize == .zero)
    XCTAssert(zero.population.isEmpty == true)
    XCTAssert(zero.recipe.genomes.isEmpty == true)
  }
  
  func test_recipeInRect() {
    let individuals = (0..<10)
      .map { Individual.init(position: .init($0, $0), genome: .init($0)) }
    
    let population = Population.init(fieldSize: .init(100, 100), population: individuals, recipe: .none())
    let rect = Vector2.Rect.init(x: 2, y: 2, width: 2, height: 2)
    
    let recipeInRect = population.recipe(in: rect)
    let expectedRecipeInRectText = "Subset of \(population.recipe.name)" // Could fail if the line order doesn't match
      + "\n1 * (2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00)"
      + "\n1 * (3.00, 3.00, 3.00, 3.00, 3.00, 3.00, 3.00, 3.00)"
      + "\n1 * (4.00, 4.00, 4.00, 4.00, 4.00, 4.00, 4.00, 4.00)"
    
    XCTAssert(recipeInRect.genomes.count == 3)
    XCTAssert(recipeInRect.description == expectedRecipeInRectText)
  }
}
