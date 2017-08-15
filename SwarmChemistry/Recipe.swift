//
//  Recipe.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/10.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Recipe
public struct Recipe {
  public typealias GenomeInfo = (genome: Parameters, count: Int)
  
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
  init?(_ recipeText: String) {
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
      self.init(recipeText, name: "Untitled")

    } else {
      let genomeText = components.dropFirst().joined(separator: lineSeparator)
      self.init(genomeText, name: firstLine)
    }
  }
  
  init?(_ recipeText: String, name: String) {
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
        return (genome: genome, count: value.count)
    }
    
    guard let genome = result as? [GenomeInfo] else {
      return nil
    }
    self.init(name: name, genomes: genome)
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

// MARK: - Function
public extension Recipe {
  static func none() -> Recipe {
    return self.init(name: "None", genomes: [])
  }
  
  static func random(numberOfGenomes: Int) -> Recipe {
    let genomes = (0..<numberOfGenomes)
      .map { _ in (genome: Parameters.random, count: 10) }
    return self.init(name: "Random", genomes: genomes)
  }
}

// MARK: - CustomStringConvertible
extension Recipe: CustomStringConvertible {
  public var description: String {
    let genomesText = genomes
      .map { "\($0.count) * \($0.genome)" }
      .joined(separator: "\n")
    
    return "\(name)\n\(genomesText)"
  }
}
