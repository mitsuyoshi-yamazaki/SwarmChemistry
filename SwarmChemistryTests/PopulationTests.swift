//
//  PopulationTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/09.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

@testable import SwarmChemistry
import XCTest

final class PopulationTests: XCTestCase {
  func test_init() {
    // Tests init won't fail
    _ = Population(.jellyFish)
    _ = Population(.none())
    _ = Population(.random(numberOfGenomes: 10))
  }

  func test_zero() {
    let empty = Population.empty()

    XCTAssert(empty.fieldSize == .zero)
    XCTAssert(empty.population.isEmpty == true)
    XCTAssert(empty.recipe.genomes.isEmpty == true)
  }

  func test_recipeInRect() {
    let individuals = (0..<10)
      .map { Individual(position: .init($0, $0), genome: .init($0)) }

    let population = Population(population: individuals, recipe: .none(), fieldSize: .init(100, 100))
    let rect = Vector2.Rect(x: 2, y: 2, width: 2, height: 2)

    let recipeInRect = population.recipe(in: rect)
    let expectedRecipeInRectText = "Subset of \(population.recipe.name)" // Could fail if the line order doesn't match
      + "\n1 * (2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00, 2.00)"
      + "\n1 * (3.00, 3.00, 3.00, 3.00, 3.00, 3.00, 3.00, 3.00)"
      + "\n1 * (4.00, 4.00, 4.00, 4.00, 4.00, 4.00, 4.00, 4.00)"

    XCTAssert(recipeInRect.genomes.count == 3)
    XCTAssert(recipeInRect.description == expectedRecipeInRectText)
  }
}
