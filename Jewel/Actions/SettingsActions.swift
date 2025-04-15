//
//  SettingsActions.swift
//  Stacks
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
  
  static func updateSettings(settings: Settings, action: SettingsAction) -> Settings {
    
    var newSettings = settings
    
    switch action {
      
    case let .firstTimeRun(firstTimeRunState):
      newSettings.firstTimeRun = firstTimeRunState
      
    case let .setPreferredPlatform(platform):
      newSettings.preferredMusicPlatform = platform
      
    case .reset:
      if let domain = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: domain)
      }
      exit(1)
      
    }
    
    return newSettings
  }
  
}
