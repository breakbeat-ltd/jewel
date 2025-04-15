//
//  DebugActions.swift
//  Stacks
//
//  Created by Greg Hepworth on 30/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

enum DebugAction: AppAction {
  
  case loadScreenshotState
  
  var description: String {
    switch self {
    case .loadScreenshotState:
      return "\(type(of: self)): Loading state for screenshots"
    }
  }
  
  static func debugUpdate(state: AppState, action: DebugAction) -> AppState {
    
    var newState = state
    
    switch action {
      
    case .loadScreenshotState:
      if let url = Bundle.main.url(forResource: "stateScreenshotData", withExtension: "json") {
        do {
          let data = try Data(contentsOf: url)
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let screenshotState = try decoder.decode(AppState.self, from: data)
          newState = screenshotState
        } catch {
          JewelLogger.debugAction.debug("💎 Screenshot Generator > Error with state: \(error.localizedDescription)")
        }
      }
      
      if let url = Bundle.main.url(forResource: "searchScreenshotData", withExtension: "json") {
        do {
          let data = try Data(contentsOf: url)
          
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let searchResults = try decoder.decode(MusicItemCollection<Album>.self, from: data)
          newState.search.results = searchResults
          
        } catch {
          JewelLogger.debugAction.debug("💎 Screenshot Generator > Error with search results: \(error.localizedDescription)")
        }
      }
      
    }
    
    return newState
    
  }
}

