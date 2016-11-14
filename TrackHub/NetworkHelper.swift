//
//  NetworkHelper.swift
//  TrackHub
//
//  Created by Luca Hagel on 11/7/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

class NetworkHelper {
  static func callGithubProfile() {
    Alamofire.request("https://github.com/luhagel").responseString { response in
      print("Success: \(response.result.isSuccess)")
      self.parseHTML(html: response.result.value!)
    }
  }
  
  static func parseHTML(html: String) {
    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
      
      var commitGraph: [Int] = []
      
      // Search for nodes by CSS
      for day in doc.css("rect[class^='day']") {
        commitGraph += [Int(day["data-count"]!)!]
      }
      
      commitGraph.popLast()
      commitGraph.popLast()
      commitGraph = commitGraph.reversed()
      
      var commitStreak = 0
      
      for day in commitGraph {
        if day != 0 {
          commitStreak += 1
        } else {
          break
        }
      }
      
      print(commitStreak)
    }
  }
}
