//
//  Recipe.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/10.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Recipe
public struct Recipe {
  public let name: String
  public let genomes: [GenomeInfo]
}

public extension Recipe {
  /**
   Expecting:
   Recipe Name
   41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)
   26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)
   ...
   */
  init?(_ recipeText: String, name: String? = nil) {
    func isGenome(_ line: String) -> Bool {
      if let (genomeText, _) = Recipe.parseLine(line) {
        if let _ = Recipe.parseGenome(from: genomeText) {
          return true
        }
      }
      return false
    }
    
    let lineSeparator = "\n"
    let components = recipeText.components(separatedBy: lineSeparator)
    let firstLine = components.first!

    if isGenome(firstLine) {
      self.init(recipeText, givenName: name ?? "Untitled")

    } else {
      let genomeText = components.dropFirst().joined(separator: lineSeparator)
      self.init(genomeText, givenName: firstLine)
    }
  }
  
  private init?(_ recipeText: String, givenName: String) {
    guard recipeText.characters.isEmpty == false else {
      return nil
    }
    
    let result = recipeText
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n")
      .map { line -> (genomeText: String, count: Int)? in
        Recipe.parseLine(line)
      }
      .map { value -> GenomeInfo? in
        guard let value = value else {
          return nil
        }
        guard let genome = Recipe.parseGenome(from: value.genomeText) else {
          return nil
        }
        return GenomeInfo.init(count: value.count, area: nil, genome: genome)
    }
    
    guard let genome = result as? [GenomeInfo] else {
      return nil
    }
    self.init(name: givenName, genomes: genome)
  }
  
  private static func parseLine(_ text: String) -> (genomeText: String, count: Int)? {
    let components = text
      .replacingOccurrences(of: " ", with: "")
      .components(separatedBy: "*")
    
    guard
      let count = Int(components.first ?? ""),
      let genomeText = components.dropFirst().first
      else {
        return nil
    }
    return (genomeText: genomeText, count: count)
  }
  
  private static func parseGenome(from text: String) -> Parameters? {
    let components = text
      .replacingOccurrences(of: " ", with: "")  // Can't just use CharacterSet?
      .replacingOccurrences(of: "(", with: "")
      .replacingOccurrences(of: ")", with: "")
      .components(separatedBy: ",")
    
    guard let values = components.map({ Value($0) }) as? [Value] else {
      Log.debug("Parse genome parameters failed: \"\(text)\"")
      return nil
    }
    return Parameters(values)
  }
}

// MARK: - Accessor
public extension Recipe {
  static func none() -> Recipe {
    return self.init(name: "None", genomes: [])
  }
  
  static func random(numberOfGenomes: Int) -> Recipe {
    let genomes = (0..<numberOfGenomes)
      .map { _ in GenomeInfo.init(count: 10, area: nil, genome: Parameters.random) }
    
    let random = self.init(name: "Random", genomes: genomes)
    Log.debug(random.description)
    
    return random
  }
  
  static func random(numberOfGenomes: Int, fieldSize: Vector2.Rect) -> Recipe {
    let genomes = (0..<numberOfGenomes)
      .map { _ in GenomeInfo.random(in: fieldSize) }
    
    let random = self.init(name: "Random", genomes: genomes)
    Log.debug(random.description)
    
    return random
  }
}

// MARK: - Operator override
public extension Recipe {
  static func +(recipe: Recipe, genome: GenomeInfo) -> Recipe {
    let name = "Expanded \(recipe.name)"
    let genomes = recipe.genomes + [genome]
    
    return Recipe.init(name: name, genomes: genomes)
  }
}

// MARK: - CustomStringConvertible
extension Recipe: CustomStringConvertible {
  public var description: String {  // TODO: Needs test
    
    var hasInitialArea = true
    genomes.forEach {
      if $0.area == nil {
        hasInitialArea = false
      }
    }
    
    let genomesText = genomes
      .map { (hasInitialArea ? "\($0.area!.description)\n" : "") + "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
    
    return "\(name)\n\(genomesText)"
  }
}

// MARK: - GenomeInfo
public extension Recipe {
  struct GenomeInfo {
    let count: Int
    let area: Vector2.Rect?
    let genome: Parameters
  }
}

public extension Recipe.GenomeInfo {
  static func random(`in` fieldSize: Vector2.Rect) -> Recipe.GenomeInfo {
    
    let count = (Int(arc4random()) % 999) + 1
    let area: Vector2.Rect = fieldSize.random()
    
    return Recipe.GenomeInfo.init(count: count, area: area, genome: .random)
  }
}
