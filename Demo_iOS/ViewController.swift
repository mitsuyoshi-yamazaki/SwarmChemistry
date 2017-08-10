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

  @IBOutlet weak var renderView: SwarmRenderView!
  var isRunning = false

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
  
  // MARK: - Function
  private func setup() {
    
    let screenSize = UIScreen.main.bounds.size
    let fieldSize = Coordinate(Value(screenSize.width), Value(screenSize.height)) * 10
    setupRenderView(with: .jellyFish, numberOfPopulation: 1000, fieldSize: fieldSize)
  }
  
  // MARK: - Action
  @IBAction func reset(sender: AnyObject!) {
    setup()
    stepSwarm(3)
  }
}

