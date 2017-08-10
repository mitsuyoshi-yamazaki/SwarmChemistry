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
  
  weak var delegate: RecipeListViewControllerDelegate?
  
  private let recipeList = Recipe.definedRecipes
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - TableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipeList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let recipe = recipeList[indexPath.row]
    
    cell.textLabel?.text = recipe.name
    
    return cell
  }
  
  // MARK: - TableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let recipe = recipeList[indexPath.row]
    delegate?.recipeListViewController(self, didSelect: recipe)
    
    dismiss(animated: true, completion: nil)
  }
}
