//
//  ConfigureWindow.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/24.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Cocoa
import SwarmChemistry

protocol ConfigureWindowDelegate: AnyObject {
  func configureWindow(_ window: ConfigureWindow, didSelect recipe: Recipe)
}

final final class ConfigureWindow: NSWindow, IBInstantiatable {
  weak var configureWindowDelegate: ConfigureWindowDelegate?
  var selectedRecipe: Recipe?

  fileprivate let recipeList = Recipe.presetRecipes

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: -
  @IBAction private func ok(sender: Any) {
    NSApp.endSheet(self)
//    endSheet(self)  // Doesn't work
  }

  @IBAction private func cancel(sender: Any) {
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
    let isSelected = recipe.name == selectedRecipe?.name
    Swift.print("\(recipe.name): \(isSelected)")

    switch ColumnIdentifier(rawValue: tableColumn.identifier) {
    case .selected:
      return isSelected ? "✔︎" : ""
    case .recipeName:
      return recipe.name
    case nil:
      fatalError("Index out of range")
    }
  }
}

extension ConfigureWindow: NSTableViewDelegate {
  func tableViewSelectionDidChange(_ notification: Notification) {
    guard let tableView = notification.object as? NSTableView else {
      fatalError("Unexpected notification object \(notification.object)")
    }
    let recipe = recipeList[tableView.selectedRow]

    selectedRecipe = recipe
    configureWindowDelegate?.configureWindow(self, didSelect: recipe)

    tableView.reloadData()
  }
}
