//
//  Utility.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/08/08.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation

public typealias Value = Double

internal struct Log {
  private enum Level {
    case debug
    case error
  }
  
  private static func log(_ message: String, _ level: Level) {
    if level == .error {
      #if DEBUG
        fatalError(message)
      #endif
    }
    print(message)
  }
  
  static func debug(_ message: String) {
    log(message, .debug)
  }
  
  static func error(_ message: String) {
    log(message, .error)
  }
}
