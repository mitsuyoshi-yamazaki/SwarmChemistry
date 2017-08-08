//
//  Utility.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017年 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public typealias Value = Double

public struct Coordinate {
  
  let x: Value
  let y: Value
  //  let z: Double // TODO: make it 3D
  
  public init(_ x: Value, _ y: Value) {
    self.x = x
    self.y = y
  }
}
