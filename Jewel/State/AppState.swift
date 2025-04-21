//
//  AppState.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct AppState: Codable {
  
  static let versionKey = "jewelState_v3_1"
  
  var navigation = Navigation()
  
  var settings: Settings
  var library: Library
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings = "options"
    case library
  }
  
}
