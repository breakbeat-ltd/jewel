//
//  SearchActions.swift
//  Stacks
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
  
  static func updateSearch(search: Search, action: SearchAction) -> Search {
    
    var newSearch = search
    
    switch action {
      
    case let .populateSearchResults(results):
      newSearch.results = results
      
    case .removeSearchResults:
      newSearch.results = nil
      
    }
    
    return newSearch
  }
  
}
