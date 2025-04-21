//
//  DebugActions.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

enum DebugAction: AppAction {
  
  case loadScreenshotState
  
  var description: String {
    switch self {
    case .loadScreenshotState:
      return "\(type(of: self)): Loading state for screenshots"
    }
  }
  
  func update(state: AppState) -> AppState {
    
    var newState = state
    
    switch self {
      
    case .loadScreenshotState:
      guard let stateScreenshotData = NSDataAsset(name: "StateScreenshotData") else {
        JewelLogger.debugAction.debug("💎 Screenshot Generator > Could not find screenshot data, state unchanged")
        return state
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let screenshotState = try decoder.decode(AppState.self, from: stateScreenshotData.data)
        newState = screenshotState
      } catch {
        JewelLogger.debugAction.debug("💎 Screenshot Generator > Error decoding screenshot state: \(error.localizedDescription)")
      }
    }
    
    guard let searchScreenshotData = NSDataAsset(name: "SearchScreenshotData") else {
      JewelLogger.debugAction.debug("💎 Screenshot Generator > Could not find search data, state unchanged")
      return state
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let searchResults = try decoder.decode(MusicItemCollection<Album>.self, from: searchScreenshotData.data)
      newState.search.results = searchResults
      
    } catch {
      JewelLogger.debugAction.debug("💎 Screenshot Generator > Error decoding search results: \(error.localizedDescription)")
    }
    
    return newState
  }
  
}


