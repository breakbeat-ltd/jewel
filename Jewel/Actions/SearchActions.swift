//
//  SearchActions.swift
//  Jewel
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

enum SearchAction: AppAction {
  
  case populateSearchResults(results: MusicItemCollection<Album>)
  case removeSearchResults
  
  var description: String {
    switch self {
    case .populateSearchResults:
      return "\(type(of: self)): Populating search results"
    case .removeSearchResults:
      return "\(type(of: self)): Removing search results"
    }
  }
  
  func update(state: AppState) -> AppState {
    
    var newState = state
    
    switch self {
      
    case let .populateSearchResults(results):
      newState.search.results = results
      
    case .removeSearchResults:
      newState.search.results = nil
      
    }
    
    return newState
  }
  
}
