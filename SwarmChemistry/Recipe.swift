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

// MARK: - Recipe List
public extension Array where Element == GenomeInfo {
  static var insurmountableWall: Recipe {
    return self.init(Raw.insurmountableWall)!
  }

  static var cellWithTwoNuclei: Recipe {
    return self.init(Raw.cellWithTwoNuclei)!
  }

  static var multicellularity: Recipe {
    return self.init(Raw.multicellularity)!
  }

  static var jellyFish: Recipe {
    return self.init(Raw.jellyFish)!
  }
  
  static var noWaitThisWay: Recipe {
    return self.init(Raw.noWaitThisWay)!
  }
}

private extension Array where Element == GenomeInfo {
  struct Raw {
    static var insurmountableWall: String {
      return ""
      + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.8, 0.01, 0.64)\n"
      + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.6)\n"
      + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.0)\n"
      + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)\n"
    }
    
    static var cellWithTwoNuclei: String {
      return ""
      + "41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)\n"
      + "26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)\n"
      + "30 * (277.87, 15.02, 24.44, 0.68, 0.05, 82.96, 0.43, 0.9)\n"
      + "28 * (110.8, 16.12, 38.6, 0.18, 0.34, 14.3, 0.01, 0.01)\n"
      + "48 * (83.79, 13.29, 7.54, 0.08, 0.79, 1.07, 0.15, 0.45)\n"
      + "74 * (269.64, 6.62, 34.69, 0.36, 0.5, 30.2, 0.03, 0.23)\n"
    }
    
    static var multicellularity: String {
      return ""
      + "99 * (19.8, 15.73, 2.61, 0.85, 0.64, 10.51, 0.17, 0.06)\n"
      + "48 * (300.0, 14.63, 0.0, 0.48, 0.81, 90.27, 0.25, 0.78)\n"
      + "37 * (275.18, 16.9, 7.05, 0.48, 0.81, 90.27, 0.17, 0.85)\n"
      + "8 * (159.59, 2.09, 24.19, 0.96, 0.59, 76.03, 0.01, 0.07)\n"
      + "42 * (73.07, 1.82, 2.36, 0.27, 0.61, 40.55, 0.22, 0.86)\n"
    }
    
    static var jellyFish: String {
      return ""
      + "134 * (262.65, 12.01, 25.87, 0.97, 1.0, 56.35, 0.26, 0.61)\n"
      + "67 * (288.17, 6.19, 23.37, 0.95, 1.0, 1.31, 0.1, 0.9)\n"
      + "68 * (150.5, 12.97, 15.87, 0.46, 0.39, 57.95, 0.17, 0.48)\n"
    }
    
    static var noWaitThisWay: String {
      return ""
      + "60 * (262.68, 2.82, 38.32, 0.21, 0.01, 54.93, 0.11, 0.19)\n"
      + "40 * (78.58, 5.7, 33.23, 0.89, 0.18, 45.44, 0.04, 0.05)\n"
      + "40 * (257.27, 14.96, 35.66, 0.2, 0.8, 47.81, 0.13, 0.13)\n"
    }
  }
}

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

// MARK: - CustomStringConvertible
public extension Array where Element == GenomeInfo {
  var description: String {
    return map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
  }
}
