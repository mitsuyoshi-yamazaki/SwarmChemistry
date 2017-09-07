//
//  Defaults.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/09/07.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import ScreenSaver
import SwarmChemistry

internal class Defaults {
  fileprivate static var moduleName: String {
    let bundle = Bundle.init(for: self)
    return bundle.bundleIdentifier!
  }
  
  fileprivate static var defaults: ScreenSaverDefaults {
    return ScreenSaverDefaults.init(forModuleWithName: moduleName)!
  }
  
  fileprivate static func fullKey(of key: String) -> String {
    return moduleName + "." + key
  }
}

extension Defaults {
  static var selectedRecipe: Recipe? {
    get {
      guard let recipeName = defaults.object(forKey: fullKey(of: "selectedRecipeName")) as? String else {
        return nil
      }
      return Recipe.presetRecipes.filter { $0.name == recipeName }.first
    }
    set {
      let defaults = self.defaults
      defaults.set(newValue?.name, forKey: fullKey(of: "selectedRecipeName"))
      defaults.synchronize()
    }
  }
}

