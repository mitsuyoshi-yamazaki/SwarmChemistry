//
//  ConfigureWindow.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/24.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

protocol ConfigureWindowDelegate: class {
  func configureWindow(_ window: ConfigureWindow, didSelect recipe: Recipe)
}

final class ConfigureWindow: NSWindow, IBInstantiatable {

  weak var configureWindowDelegate: ConfigureWindowDelegate?
  var currentRecipe: Recipe?

  fileprivate let recipeList = Recipe.presetRecipes
  
  // MARK: -
  @IBAction func ok(sender: AnyObject!) {
    NSApp.endSheet(self)
//    endSheet(self)  // Doesn't work
  }
  
  @IBAction func cancel(sender: AnyObject!) {
    NSApp.endSheet(self)
    //    endSheet(self)  // Doesn't work
  }
}

extension ConfigureWindow: NSTableViewDataSource {
  private enum ColumnIdentifier: String {
    case selected   = "Selected"
    case recipeName = "RecipeName"
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return recipeList.count
  }
  
  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    guard let tableColumn = tableColumn else {
      Swift.print("No tableColumn specified")
      return nil
    }
    
    let recipe = recipeList[row]
    
    switch ColumnIdentifier.init(rawValue: tableColumn.identifier)! {
    case .selected:
      return "✔︎"
    case .recipeName:
      return recipe.name
    }
  }
}
