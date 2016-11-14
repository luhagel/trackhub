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
    Alamofire.request("http://github.com/luhagel").responseString { response in
      print("Success: \(response.result.isSuccess)")
      self.parseHTML(html: response.result.value!)
    }
  }
  
  static func parseHTML(html: String) {
    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
      
      var daycounter = 0
      
      // Search for nodes by CSS
      for day in doc.css("rect[class^='day']") {
        daycounter += 1
      }
      
      print(daycounter)
    }
  }
}
