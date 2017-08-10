//
//  Recipe.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/10.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Recipe
public typealias GenomeInfo = (genome: Parameters, count: Int)
public typealias Recipe = [GenomeInfo]

// TODO: write tests

// MARK: - Convenience initializer
public extension Array where Element == GenomeInfo {
  /**
   Expecting:
   41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)
   26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)
   ...
   */
  init?(_ recipeText: String) {
    func parseLine(_ text: String) -> (genomeText: String, count: Int)? {
      let components = text
        .replacingOccurrences(of: " ", with: "")
        .components(separatedBy: "*")
      
      guard
        let count = Int(components.first ?? ""),
        let genomeText = components.dropFirst().first
        else {
          Log.debug("Parse line failed: \"\(text)\"")
          return nil
      }
      return (genomeText: genomeText, count: count)
    }
    func parseGenome(from text: String) -> Parameters? {
      let components = text
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
        .components(separatedBy: ",")
      
      guard let values = components.map({ Value($0) }) as? [Value] else {
        Log.debug("Parse genome parameters failed: \"\(text)\"")
        return nil
      }
      return Parameters(values)
    }
    
    let result = recipeText
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n")
      .map { line -> (genomeText: String, count: Int)? in
        parseLine(line)
      }
      .map { value -> GenomeInfo? in
        guard let value = value else {
          return nil
        }
        guard let genome = parseGenome(from: value.genomeText) else {
          return nil
        }
        return (genome: genome, count: value.count)
    }
    
    guard let recipe = result as? [GenomeInfo] else {
      Log.debug("Parsing recipe failed")
      return nil
    }
    self.init(recipe)
  }
}

// MARK: - Function
public extension Array where Element == GenomeInfo {
  static func random(numberOfGenomes: Int) -> Recipe {
    return (0..<numberOfGenomes)
      .map { _ in (genome: Parameters.random, count: 10) }
  }
}

// MARK: - CustomStringConvertible
public extension Array where Element == GenomeInfo {
  var description: String {
    return map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
  }
}
