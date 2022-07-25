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

internal final class Defaults {
  fileprivate static var moduleName: String {
    guard let bundleIdentifier = Bundle(for: self).bundleIdentifier else {
      fatalError("Missing bundleIdentifier")
    }
    return bundleIdentifier
  }

  fileprivate static var defaults: ScreenSaverDefaults {
    guard let screenSaverDefaults = ScreenSaverDefaults(forModuleWithName: moduleName) else {
      fatalError("Missing screenSaverDefaults")
    }
    return screenSaverDefaults
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
      return Recipe.presetRecipes.first { $0.name == recipeName }
    }
    set {
      let defaults = self.defaults
      defaults.set(newValue?.name, forKey: fullKey(of: "selectedRecipeName"))
      defaults.synchronize()
    }
  }
}
