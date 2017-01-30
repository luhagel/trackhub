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
  static func checkStatusCode(name: String, completion: @escaping (Int) -> Void) {
    Alamofire.request("https://github.com/\(name)")
      .responseString { response in
        completion((response.response?.statusCode)!)
    }
  }
  static func getCurrentStreakFor(username: String, completion: @escaping (Int) -> Void) {
    Alamofire.request("https://github.com/\(username)").responseString { response in
      completion(self.parseStreakFromHTML(html: response.result.value!))    }
  }
  
  static func getProfilePictureFor(username: String, completion: @escaping (String) -> Void) {
    Alamofire.request("https://github.com/\(username)").responseString { response in
      completion(self.parseProfilePictureURLFromHTML(html: response.result.value!))    }
  }
  
  static func parseProfilePictureURLFromHTML(html: String) -> String {
    var profilePictureURL = ""
    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
      for picture in doc.css("img[class^='avatar width-full rounded-2']") {
        if let url = picture["src"] {
          profilePictureURL = String(url)
        }
      }
    }
    return profilePictureURL
  }
  
  static func parseStreakFromHTML(html: String) -> Int {
    var commitStreak = 0
    
    if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
      
      var commitGraph: [Int] = []
      
      // Search for nodes by CSS
      for day in doc.css("rect[class^='day']") {
        commitGraph += [Int(day["data-count"]!)!]
      }
      
      commitGraph.removeLast()
      commitGraph = commitGraph.reversed()
      
      for day in commitGraph {
        if day != 0 {
          commitStreak += 1
        } else {
          break
        }
      }
    }
    return commitStreak
  }
}
