//
//  RecipeInputViewController.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/14.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import UIKit
import SwarmChemistry

protocol RecipeInputViewControllerDelegate: class {
  func recipeInputViewController(_ controller: RecipeInputViewController, didInput recipe: Recipe)
}

class RecipeInputViewController: UIViewController {

  weak var delegate: RecipeInputViewControllerDelegate?
  var currentRecipe: Recipe? {
    didSet {
      textView?.text = currentRecipe?.description ?? ""
    }
  }

  @IBOutlet private weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textView.text = currentRecipe?.description ?? ""
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    textView.becomeFirstResponder()
  }

  @IBAction func done(sender: AnyObject!) {
    guard let recipe = Recipe.init(textView.text, name: "Manual Input") else {
      let alertController = UIAlertController.init(title: "Error", message: "Cannot parse recipe", preferredStyle: .alert)
      alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
      
      present(alertController, animated: true, completion: nil)
      return
    }
    
    currentRecipe = recipe
    let delegate = self.delegate
    
    dismiss(animated: true) {
      delegate?.recipeInputViewController(self, didInput: recipe)
    }
  }
}
