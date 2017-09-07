//
//  Request.swift
//  SwarmChemistry
//
//  Created by mitsuyoshi.yamazaki on 2017/09/07.
//  Copyright © 2017 Mitsuyoshi Yamazaki. All rights reserved.
//

import Foundation
import SwarmChemistry

struct Request {
  static func send(recipe: Recipe) {  // TODO: Callback
    guard let data = try? JSONSerialization.data(withJSONObject: ["raw": recipe.description], options: []) else {
      Swift.print("Serializing to JSON failed")
      return
    }
    
    let path = Constants.dataServerURL + "recipes"
    let url = URL.init(string: path)!
    var request = URLRequest.init(url: url)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = data
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard
        let nonNilData = data,
        error == nil,
        let result = try? JSONSerialization.jsonObject(with: nonNilData, options: []) as? [String: Any]
        else {
          Swift.print("Failed to send recipe")
          return
      }
      guard let recipeID = result?["id"] as? Int else {
        Swift.print("Faild to parse the response data")
        Swift.print(String.init(describing: result))
        return
      }
      Swift.print("Sending recipe succeeded")
    }
    task.resume()
  }
}
