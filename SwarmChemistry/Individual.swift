//
//  Individual.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public struct Individual {
  
  public var position: Coordinate
  public let genome: Parameters
  
  public init(position: Coordinate, genome: Parameters) {
    self.position = position
    self.genome = genome
  }
}
