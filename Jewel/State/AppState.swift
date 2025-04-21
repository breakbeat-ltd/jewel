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
  
  static func updateState(appState: AppState, action: AppAction) -> AppState {
    
    JewelLogger.stateUpdate.info("💎 State Update > \(action.description)")
    
    var newAppState = appState
    
    switch action {
      
    case is NavigationAction:
      newAppState.navigation = NavigationAction.updateNavigation(navigation: newAppState.navigation, action: action as! NavigationAction)
      
    case is SettingsAction:
      newAppState.settings = SettingsAction.updateSettings(settings: newAppState.settings, action: action as! SettingsAction)
      
    case is LibraryAction:
      newAppState.library = LibraryAction.updateLibrary(library: newAppState.library, action: action as! LibraryAction)
      
    case is SearchAction:
      newAppState.search = SearchAction.updateSearch(search: newAppState.search, action: action as! SearchAction)
      
    case is DebugAction:
      newAppState = DebugAction.debugUpdate(state: newAppState, action: action as! DebugAction)
      
    default: break
      
    }
    
    return newAppState
  }
  
}
