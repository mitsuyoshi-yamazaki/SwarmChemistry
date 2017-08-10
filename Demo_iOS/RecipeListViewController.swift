//
//  RecipeListViewController.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/11.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import UIKit
import SwarmChemistry

protocol RecipeListViewControllerDelegate: class {
  func recipeListViewController(_ controller: RecipeListViewController, didSelect recipe: (name: String, recipe: Recipe))
}

class RecipeListViewController: UITableViewController {
  enum Section: Int {
    case random
    case preset
  }
  
  weak var delegate: RecipeListViewControllerDelegate?
  
  private let recipeList = Recipe.definedRecipes
  
  private func recipe(at indexPath: IndexPath) -> (name: String, recipe: Recipe) {
    switch Section.init(rawValue: indexPath.section)! {
    case .random:
      return (name: "Random", Recipe.random(numberOfGenomes: 5))
    case .preset:
      return recipeList[indexPath.row]
    }
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - TableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section.init(rawValue: section)! {
    case .random:
      return 1
    case .preset:
      return recipeList.count
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let recipe = self.recipe(at: indexPath)
    
    cell.textLabel?.text = recipe.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch Section.init(rawValue: section)! {
    case .random:
      return nil
    case .preset:
      return "Preset"
    }
  }
  
  // MARK: - TableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let recipe = self.recipe(at: indexPath)
    delegate?.recipeListViewController(self, didSelect: recipe)
    
    dismiss(animated: true, completion: nil)
  }
}
