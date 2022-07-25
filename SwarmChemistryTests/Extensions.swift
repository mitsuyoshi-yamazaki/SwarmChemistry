//
//  Extensions.swift
//  SwarmChemistry
//
//  Created by Yamazaki Mitsuyoshi on 2017/08/15.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

@testable import SwarmChemistry

extension Parameters {
  init(_ value: Int) {
    let numberOfParameters = 8
    let values = (0..<numberOfParameters).map { _ in Value(value) }
    self.init(values)!  // swiftlint:disable:this force_unwrapping
  }
}
