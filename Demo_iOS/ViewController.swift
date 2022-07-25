//
//  ViewController.swift
//  Demo_iOS
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/10.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import SwarmChemistry
import UIKit

private let numberOfPopulation = 500
private let numberOfStepsInOneFrame = 4
private let intervalBetweenSteps = 0.0

final class ViewController: UIViewController, SwarmRenderer {
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var recipeSelectionButton: UIButton!
  @IBOutlet private var resumeButton: UIButton!
  @IBOutlet private var shareButton: UIButton!

  fileprivate var isRecipeSaved = false
  fileprivate var selectedRecipe = Recipe.slicer
  fileprivate var shouldRun = false

  // MARK: - SwarmRenderer
  @IBOutlet private var swarmRenderView: SwarmRenderView!
  var renderView: SwarmRenderView! {
    return swarmRenderView
  }
  var timer: Timer? {
    didSet {
      resumeButton.isHidden = (timer != nil)
    }
  }
  var isRunning: Bool {
    guard let timer = timer else { return false }
    return timer.isValid
  }
  var steps: Int {
    return numberOfStepsInOneFrame
  }
  var delay: Double {
    return intervalBetweenSteps
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
      start()
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
    let population = Population(
      selectedRecipe,
      numberOfPopulation: numberOfPopulation,
      fieldSize: fieldSize,
      initialArea: Vector2.Rect(origin: fieldSize * 0.45, size: fieldSize * 0.1)
    )

    setupRenderView(with: population)

    isRecipeSaved = false
    shouldRun = true
  }

  // MARK: - Action
  @IBAction private func reset(sender: Any) {
    setup()
    start()
  }

  @IBAction private func pause(sender: Any) {
    guard isRunning == true else {
      return
    }
    pause()
  }

  @IBAction private func resume(sender: Any) {
    guard isRunning == false else {
      return
    }
    start()
  }

  @IBAction private func share(sender: Any) {
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

    let completionHandler: UIActivityViewController.CompletionWithItemsHandler = { [weak self] _, _, _, _  in
      self?.start()
    }

    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    activityViewController.completionWithItemsHandler = completionHandler
    activityViewController.modalPresentationStyle = .popover

    let popoverPresentationController = activityViewController.popoverPresentationController
    popoverPresentationController?.sourceView = view
    popoverPresentationController?.sourceRect = shareButton.frame

    present(activityViewController, animated: true, completion: nil)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "SelectRecipe":
      guard let navigationController = segue.destination as? UINavigationController else {
        fatalError("Unexpected destination")
      }
      guard let recipeListViewController = navigationController.topViewController as? RecipeListViewController else {
        fatalError("Unexpected destination")
      }
      recipeListViewController.delegate = self
      recipeListViewController.currentRecipe = selectedRecipe
    default:
      fatalError("Unrecognized segue identifier \(String(describing: segue.identifier))")
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
      start()
      shouldRun = false
    }
  }
}
