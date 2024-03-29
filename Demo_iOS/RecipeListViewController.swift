//
//  RecipeListViewController.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/11.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import SwarmChemistry
import UIKit

protocol RecipeListViewControllerDelegate: AnyObject {
  func recipeListViewController(_ controller: RecipeListViewController, didSelect recipe: Recipe)
}

final class RecipeListViewController: UITableViewController {
  enum Section: Int {
    case random
    case input
    case preset

    static let count = 3
  }

  weak var delegate: RecipeListViewControllerDelegate?
  var currentRecipe: Recipe?

  private let recipeList = Recipe.presetRecipes

  private func recipe(at indexPath: IndexPath) -> Recipe {
    switch Section(rawValue: indexPath.section) {
    case .random:
      return Recipe.random(numberOfGenomes: 5)
    case .preset:
      return recipeList[indexPath.row]
    case .input:
      fatalError("Not implemented yet")  // TODO:
    case nil:
      fatalError("Index out of bounds")
    }
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - TableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return Section.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .random:
      return 1
    case .preset:
      return recipeList.count
    case .input:
      return 1
    case nil:
      fatalError("Index out of bounds")
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    guard indexPath.section != Section.input.rawValue else {
      cell.textLabel?.text = "Input Manually"
      return cell
    }

    let recipe = self.recipe(at: indexPath)

    cell.textLabel?.text = recipe.name

    return cell
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch Section(rawValue: section) {
    case .random:
      return nil
    case .preset:
      return "Preset"
    case .input:
      return nil
    case nil:
      fatalError("Index out of bounds")
    }
  }

  // MARK: - TableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section != Section.input.rawValue else {
      performSegue(withIdentifier: "InputRecipe", sender: self)
      return
    }

    let recipe = self.recipe(at: indexPath)
    delegate?.recipeListViewController(self, didSelect: recipe)

    dismiss(animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "InputRecipe":
      guard let inputViewController = segue.destination as? RecipeInputViewController else {
        fatalError("Unexpected destination")
      }
      inputViewController.delegate = self
      inputViewController.currentRecipe = currentRecipe
    default:
      fatalError("Unrecognized segue identifier \(segue.identifier)")
    }
  }
}

extension RecipeListViewController: RecipeInputViewControllerDelegate {
  func recipeInputViewController(_ controller: RecipeInputViewController, didInput recipe: Recipe) {
    delegate?.recipeListViewController(self, didSelect: recipe)
    dismiss(animated: true, completion: nil)
  }
}
