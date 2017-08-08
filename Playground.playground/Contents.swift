//: Playground - noun: a place where people can play

import Cocoa
import SwarmChemistry

var str = "Hello, playground"

let params = (0..<8).map { Double($0) }

print(SwarmChemistry.Parameters.init(params))
