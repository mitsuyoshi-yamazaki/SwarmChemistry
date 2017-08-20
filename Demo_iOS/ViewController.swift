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
  
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var recipeSelectionButton: UIButton!
  @IBOutlet private weak var resumeButton: UIButton!
  @IBOutlet private weak var shareButton: UIButton!

  fileprivate var isRecipeSaved = false
  fileprivate var selectedRecipe = Recipe.slicer
  fileprivate var shouldRun = false
  
  // MARK: - SwarmRenderer
  @IBOutlet weak var renderView: SwarmRenderView!
  var isRunning = false {
    didSet {
      resumeButton.isHidden = isRunning
    }
  }
  var steps: Int {
    return 3
  }
  var delay: Double {
    return 0.0
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    scrollView.maximumZoomScale = CGFloat(renderView.population.fieldSize.x) / 400.0
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: true)
    if shouldRun {
      resume()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    shouldRun = isRunning
    pause()
  }
  
  // MARK: - Function
  private func setup() {
    
    recipeSelectionButton.setTitle(selectedRecipe.name, for: .normal)
    
    let screenSize = UIScreen.main.bounds.size
    let fieldSize = Vector2(Value(screenSize.width), Value(screenSize.height)) * 10
    let population = Population.init(selectedRecipe,
                                     numberOfPopulation: 1000,
                                     fieldSize: fieldSize,
                                     initialArea: Vector2.Rect.init(origin: fieldSize * 0.45, size: fieldSize * 0.1))
    
    setupRenderView(with: population)
    
    isRecipeSaved = false
    shouldRun = true
  }
  
  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    resume()
  }
  
  @IBAction func pause(sender: AnyObject!) {
    guard isRunning == true else {
      return
    }
    pause()
  }

  @IBAction func resume(sender: AnyObject!) {
    guard isRunning == false else {
      return
    }
    resume()
  }

  @IBAction func share(sender: AnyObject!) {
    
    let recipe: Recipe
    if scrollView.zoomScale == 1.0 {
      recipe = renderView.population.recipe
    } else {
      let visibleRect = renderView.convert(scrollView.visibleRect)
      recipe = renderView.population.recipe(in: visibleRect)
    }
    
    let shareText = recipe.description
    var activityItems: [Any] = [
      shareText
    ]
    if let shareImage = renderView.takeScreenshot() {
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
      recipeListViewController.currentRecipe = selectedRecipe
    }
  }
}

extension ViewController: RecipeListViewControllerDelegate {
  func recipeListViewController(_ controller: RecipeListViewController, didSelect recipe: Recipe) {
    selectedRecipe = recipe
    reset(sender: self)
  }
}

extension ViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return renderView
  }
  
  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    shouldRun = isRunning
    pause()
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    if shouldRun {
      resume()
      shouldRun = false
    }
  }
}
