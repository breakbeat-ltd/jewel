//
//  SettingsActions.swift
//  Jewel
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

enum SettingsAction: AppAction {
  
  case firstTimeRun(Bool)
  case setPreferredPlatform(platform: OdesliPlatform)
  case reset
  
  var description: String {
    switch self {
    case .setPreferredPlatform(let platform):
      return "\(type(of: self)): Setting preferred platform to \(String(describing: platform))"
    case .firstTimeRun(let firstTime):
      return "\(type(of: self)): \(firstTime ? "Setting to" : "Clearing") first time run"
    case .reset:
      return "\(type(of: self)): Performing reset"
    }
  }
  
  func update(state: AppState) -> AppState {
    
    var newState = state
    
    switch self {
      
    case let .firstTimeRun(firstTimeRunState):
      newState.settings.firstTimeRun = firstTimeRunState
      
    case let .setPreferredPlatform(platform):
      newState.settings.preferredMusicPlatform = platform
      
    case .reset:
      if let domain = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: domain)
      }
      exit(1)
      
    }
    
    return newState
  }
  
}
