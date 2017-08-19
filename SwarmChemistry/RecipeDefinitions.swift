//
//  RecipeDefinitions.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/11.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

// MARK: - Recipe List
public extension Recipe {
  static var presetRecipes: [Recipe] {
    return [
      slicer,
      oscillator,
      insurmountableWall,
      cellWithTwoNuclei,
      multicellularity,
      jellyFish,
      noWaitThisWay,
      recombiningBlobs,
      playingCatch,
      pulsatingEye,
      chaosCells,
      aggressivePredator,
      fastWalkerAndSlowFollower,
      swinger,
      rotary,
      weddingRing,
      turbulentRunner,
      blobs,
      linearOscillator,
    ]
    // More recipes see: http://bingweb.binghamton.edu/~sayama/SwarmChemistry/
  }

  static var slicer: Recipe {
    return self.init(Raw.slicer)!
  }

  static var oscillator: Recipe {
    return self.init(Raw.oscillator)!
  }

  // MARK: -
  static var insurmountableWall: Recipe {
    return self.init(Raw.insurmountableWall)!
  }
  
  static var cellWithTwoNuclei: Recipe {
    return self.init(Raw.cellWithTwoNuclei)!
  }
  
  static var multicellularity: Recipe {
    return self.init(Raw.multicellularity)!
  }
  
  static var jellyFish: Recipe {
    return self.init(Raw.jellyFish)!
  }
  
  static var noWaitThisWay: Recipe {
    return self.init(Raw.noWaitThisWay)!
  }
  
  static var recombiningBlobs: Recipe {
    return self.init(Raw.recombiningBlobs)!
  }
  
  static var playingCatch: Recipe {
    return self.init(Raw.playingCatch)!
  }
  
  static var pulsatingEye: Recipe {
    return self.init(Raw.pulsatingEye)!
  }
  
  static var chaosCells: Recipe {
    return self.init(Raw.chaosCells)!
  }
  
  static var aggressivePredator: Recipe {
    return self.init(Raw.aggressivePredator)!
  }
  
  static var fastWalkerAndSlowFollower: Recipe {
    return self.init(Raw.fastWalkerAndSlowFollower)!
  }
  
  static var swinger: Recipe {
    return self.init(Raw.swinger)!
  }
  
  static var rotary: Recipe {
    return self.init(Raw.rotary)!
  }
  
  static var weddingRing: Recipe {
    return self.init(Raw.weddingRing)!
  }
  
  static var turbulentRunner: Recipe {
    return self.init(Raw.turbulentRunner)!
  }
  
  static var blobs: Recipe {
    return self.init(Raw.blobs)!
  }
  
  static var linearOscillator: Recipe {
    return self.init(Raw.linearOscillator)!
  }
}

private extension Recipe {
  struct Raw {
    
    static var slicer: String {
      return "Slicer\n"
        + "12 * (86.89, 1.8, 22.26, 0.57, 0.35, 80.8, 0.35, 0.64)\n"
        + "1 * (140.55, 2.52, 20.39, 0.97, 0.45, 35.51, 0.45, 0.06)\n"
    }

    static var oscillator: String {
      return "Oscillator\n"
        + "500 * (200.0, 20.0, 40.0, 0.64, 0.01, 0.29, 0.08, 0.97)\n"
        + "120 * (300.0, 7.19, 15.51, 1.0, 0.33, 32.65, 0.34, 0.56)\n"
    }
    
    // MARK: -
    static var insurmountableWall: String {
      return "Insurmountable Wall\n"
        + "42 * (52.57, 9.91, 20.42, 0.32, 0.76, 1.8, 0.01, 0.64)\n"
        + "25 * (84.87, 8.82, 24.98, 0.91, 0.44, 40.97, 0.18, 0.6)\n"
        + "45 * (220.42, 4.65, 7.53, 0.96, 0.35, 46.18, 0.25, 1.0)\n"
        + "49 * (279.64, 10.29, 35.95, 0.37, 0.49, 38.09, 0.32, 0.89)\n"
    }
    
    static var cellWithTwoNuclei: String {
      return "Cell With 2 Nuclei\n"
        + "41 * (249.84, 4.85, 28.73, 0.34, 0.45, 14.44, 0.09, 0.82)\n"
        + "26 * (277.87, 15.02, 35.48, 0.68, 0.05, 82.96, 0.46, 0.9)\n"
        + "30 * (277.87, 15.02, 24.44, 0.68, 0.05, 82.96, 0.43, 0.9)\n"
        + "28 * (110.8, 16.12, 38.6, 0.18, 0.34, 14.3, 0.01, 0.01)\n"
        + "48 * (83.79, 13.29, 7.54, 0.08, 0.79, 1.07, 0.15, 0.45)\n"
        + "74 * (269.64, 6.62, 34.69, 0.36, 0.5, 30.2, 0.03, 0.23)\n"
    }
    
    static var multicellularity: String {
      return "Multicellularity\n"
        + "99 * (19.8, 15.73, 2.61, 0.85, 0.64, 10.51, 0.17, 0.06)\n"
        + "48 * (300.0, 14.63, 0.0, 0.48, 0.81, 90.27, 0.25, 0.78)\n"
        + "37 * (275.18, 16.9, 7.05, 0.48, 0.81, 90.27, 0.17, 0.85)\n"
        + "8 * (159.59, 2.09, 24.19, 0.96, 0.59, 76.03, 0.01, 0.07)\n"
        + "42 * (73.07, 1.82, 2.36, 0.27, 0.61, 40.55, 0.22, 0.86)\n"
    }
    
    static var jellyFish: String {
      return "Jelly Fish\n"
        + "134 * (262.65, 12.01, 25.87, 0.97, 1.0, 56.35, 0.26, 0.61)\n"
        + "67 * (288.17, 6.19, 23.37, 0.95, 1.0, 1.31, 0.1, 0.9)\n"
        + "68 * (150.5, 12.97, 15.87, 0.46, 0.39, 57.95, 0.17, 0.48)\n"
    }
    
    static var noWaitThisWay: String {
      return "No, Wait - This Way\n"
        + "60 * (262.68, 2.82, 38.32, 0.21, 0.01, 54.93, 0.11, 0.19)\n"
        + "40 * (78.58, 5.7, 33.23, 0.89, 0.18, 45.44, 0.04, 0.05)\n"
        + "40 * (257.27, 14.96, 35.66, 0.2, 0.8, 47.81, 0.13, 0.13)\n"
    }
    
    static var recombiningBlobs: String {
      return "Recombining Blobs\n"
        + "132 * (45.91, 10.82, 21.11, 0.86, 0.13, 42.48, 0.32, 0.74)\n"
        + "84 * (113.26, 3.41, 25.71, 0.4, 0.39, 49.53, 0.13, 0.24)\n"
    }
    
    static var playingCatch: String {
      return "Playing Catch\n"
        + "76 * (84.06, 0.09, 9.89, 0.33, 0.32, 15.66, 0.22, 0.68)\n"
        + "100 * (158.86, 18.4, 24.98, 0.3, 0.3, 1.72, 0.06, 0.37)\n"
    }
    
    static var pulsatingEye: String {
      return "Pulsating Eye\n"
        + "102 * (293.86, 17.06, 38.3, 0.81, 0.05, 0.83, 0.2, 0.9)\n"
        + "124 * (226.18, 19.27, 24.57, 0.95, 0.84, 13.09, 0.07, 0.8)\n"
        + "74 * (49.98, 8.44, 4.39, 0.92, 0.14, 96.92, 0.13, 0.51)\n"
    }
    
    static var chaosCells: String {
      return "Chaos Cells\n"
        + "144 * (109.03, 6.71, 12.7, 0.47, 0.6, 61.43, 0.02, 0.21)\n"
        + "89 * (117.15, 16.33, 31.88, 0.39, 0.13, 12.96, 0.48, 0.8)\n"
        + "67 * (76.3, 8.59, 26.57, 0.7, 0.64, 28.39, 0.3, 0.35)\n"
    }
    
    static var aggressivePredator: String {
      return "Aggressive Predator\n"
        + "18 * (211.92, 12.59, 19.37, 0.09, 0.21, 57.92, 0.0, 0.95)\n"
        + "41 * (257.27, 14.96, 35.66, 0.2, 0.8, 47.81, 0.13, 0.13)\n"
        + "35 * (262.68, 2.82, 38.32, 0.21, 0.01, 54.93, 0.11, 0.19)\n"
        + "31 * (78.58, 5.7, 33.23, 0.89, 0.18, 45.44, 0.04, 0.05)\n"
        + "7 * (194.21, 12.88, 21.68, 0.97, 0.19, 99.21, 0.5, 0.13)\n"
    }
    
    static var fastWalkerAndSlowFollower: String {
      return "Fast Walker And Slow Follower\n"
        + "67 * (216.35, 11.75, 7.7, 0.83, 0.97, 97.31, 0.02, 0.38)\n"
        + "29 * (254.64, 7.28, 7.0, 0.95, 0.11, 22.41, 0.43, 0.31)\n"
        + "13 * (105.4, 3.55, 5.24, 0.34, 0.18, 23.53, 0.39, 0.24)\n"
    }
    
    static var swinger: String {
      return "Swinger\n"
        + "48 * (150.39, 15.89, 23.54, 0.74, 0.45, 62.65, 0.33, 0.13)\n"
        + "152 * (217.14, 12.13, 12.42, 0.59, 0.98, 14.06, 0.04, 0.65)\n"
        + "14 * (248.54, 5.85, 22.26, 0.43, 0.11, 17.14, 0.06, 0.68)\n"
        + "31 * (141.53, 2.91, 4.86, 0.92, 0.03, 21.87, 0.28, 0.2)\n"
    }
    
    static var rotary: String {
      return "Rotary\n"
        + "29 * (122.13, 19.19, 17.98, 0.65, 0.44, 19.88, 0.46, 0.2)\n"
        + "51 * (299.13, 0.79, 38.71, 0.25, 0.18, 86.49, 0.38, 0.43)\n"
        + "10 * (252.92, 19.99, 10.21, 0.23, 0.17, 1.22, 0.28, 0.92)\n"
    }
    
    static var weddingRing: String {
      return "Wedding Ring\n"
        + "24 * (220.51, 13.88, 3.47, 0.46, 0.38, 6.23, 0.19, 0.68)\n"
        + "13 * (64.07, 1.4, 19.7, 0.88, 0.27, 0.36, 0.47, 0.72)\n"
        + "35 * (117.53, 7.31, 21.72, 0.3, 0.5, 98.69, 0.03, 0.29)\n"
    }
    
    static var turbulentRunner: String {
      return "Turbulent Runner\n"
        + "131 * (177.1, 9.71, 30.06, 0.8, 0.43, 19.65, 0.45, 0.91)\n"
        + "169 * (277.3, 14.67, 37.71, 0.68, 0.23, 77.01, 0.02, 0.31)\n"
    }
    
    static var blobs: String {
      return "Blobs\n"
        + "300 * (20.8, 1.95, 20.75, 0.95, 0.99, 9.31, 0.05, 0.68)\n"
    }
    
    static var linearOscillator: String {
      return "Linear Oscillator\n"
        + "133 * (214.41, 17.93, 35.14, 0.64, 0.13, 0.29, 0.08, 0.97)\n"
        + "24 * (253.6, 7.19, 15.51, 0.82, 0.33, 32.65, 0.34, 0.56)\n"
    }
  }
}
