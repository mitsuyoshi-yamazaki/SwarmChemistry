//
//  RecipeTests.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/15.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import XCTest
@testable import SwarmChemistry

class RecipeTests: XCTestCase {
  
  func test_parseRecipeWithName() {
    let recipeName = "Insurmountable Wall"
    let recipeText = recipeName + "\n"
      + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.8, 0.01, 0.64)\n"
      + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.6)\n"
      + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.0)\n"
      + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)\n"
    
    let recipe = Recipe.init(recipeText)
    
    XCTAssert(recipe != nil)
    XCTAssert(recipe!.name == recipeName)
    XCTAssert(recipe!.genomes.count == 4)
  }
  
  func test_parseRecipe() {
    let recipeText = ""
      + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.8, 0.01, 0.64)\n"
      + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.6)\n"
      + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.0)\n"
      + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)\n"
    
    let recipe = Recipe.init(recipeText, name: "Insurmountable Wall")
    
    XCTAssert(recipe != nil)
    XCTAssert(recipe!.genomes.count == 4)
  }
  
  func test_none() {
    XCTAssert(Recipe.none().genomes.isEmpty)
  }
  
  func test_random() {
    let numberOfGenomes = 10
    let recipe = Recipe.random(numberOfGenomes: numberOfGenomes)
    
    XCTAssert(recipe.genomes.count == numberOfGenomes)
  }
  
  func test_operators() {
    let recipeName = "Insurmountable Wall"
    let recipeText = recipeName + "\n"
      + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.80, 0.01, 0.64)\n"
      + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.60)\n"
      + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.00)\n"
    
    let recipe = Recipe.init(recipeText)!
    
    let genome = Parameters([279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89])!
    let additionalGenome = Recipe.GenomeInfo.init(count: 49, area: nil, genome: genome)
    
    let expectedRecipeDescription = "Expanded " + recipeText
      + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)"
    
    XCTAssert((recipe + additionalGenome).description == expectedRecipeDescription)
  }
}
