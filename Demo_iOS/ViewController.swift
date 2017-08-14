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
  
  @IBOutlet private weak var recipeSelectionButton: UIButton!
  @IBOutlet private weak var shareButton: UIButton!
  @IBOutlet weak var renderView: SwarmRenderView!
  
  var isRunning = false
  fileprivate var isRecipeSaved = false
  fileprivate var selectedRecipe = Recipe.jellyFish
  
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
    
    recipeSelectionButton.setTitle(selectedRecipe.name, for: .normal)
    
    let screenSize = UIScreen.main.bounds.size
    let fieldSize = Coordinate(Value(screenSize.width), Value(screenSize.height)) * 10
    setupRenderView(with: selectedRecipe, numberOfPopulation: 1000, fieldSize: fieldSize)
    
    isRecipeSaved = false
  }
  
  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    stepSwarm(3)
  }
  
  @IBAction func share(sender: AnyObject!) {
    guard let recipeText = renderView.population?.description else {  // Currently Population?.description is the recipe text representable
      print("No population")
      return
    }
    
    let shareText = "\(selectedRecipe.name)\n\(recipeText)"
    var activityItems: [Any] = [
      shareText
    ]
    if  let shareImage = renderView.takeScreenshot() {
      activityItems.append(shareImage)
    }
    
    let completionHandler: UIActivityViewControllerCompletionWithItemsHandler = { [unowned self] _ in
      self.isRunning = true
    }
    
    let activityViewController = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
    activityViewController.completionWithItemsHandler = completionHandler // FixMe: Not working
    
    let popoverPresentationController = activityViewController.popoverPresentationController!
    popoverPresentationController.sourceView = view
    popoverPresentationController.sourceRect = shareButton.frame
    
    present(activityViewController, animated: true, completion: nil)
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
  func recipeListViewController(_ controller: RecipeListViewController, didSelect recipe: Recipe) {
    selectedRecipe = recipe
    reset(sender: self)
  }
}
