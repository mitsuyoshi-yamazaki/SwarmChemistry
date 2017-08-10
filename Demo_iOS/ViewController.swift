//
//  ViewController.swift
//  Demo_iOS
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/10.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import UIKit
import SwarmChemistry

class ViewController: UIViewController, SwarmRenderer {
  enum SegueIdentifier: String {
    case selectRecipe = "SelectRecipe"
  }
  
  @IBOutlet weak var renderView: SwarmRenderView!
  var isRunning = false

  fileprivate var selectedRecipe = (name: "JellyFish", recipe: Recipe.jellyFish)
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: true)
    stepSwarm(3)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    isRunning = false
  }
  
  // MARK: - Function
  private func setup() {
    
    let screenSize = UIScreen.main.bounds.size
    let fieldSize = Coordinate(Value(screenSize.width), Value(screenSize.height)) * 10
    setupRenderView(with: selectedRecipe.recipe, numberOfPopulation: 1000, fieldSize: fieldSize)
  }
  
  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    stepSwarm(3)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch SegueIdentifier.init(rawValue: segue.identifier!)! {
    case .selectRecipe:
      let navigationController = segue.destination as! UINavigationController
      let recipeListViewController = navigationController.topViewController as! RecipeListViewController
      recipeListViewController.delegate = self
    }
  }
}

extension ViewController: RecipeListViewControllerDelegate {
  func recipeListViewController(_ controller: RecipeListViewController, didSelect recipe: (name: String, recipe: Recipe)) {
    selectedRecipe = recipe
    reset(sender: self)
  }
}
