//
//  AppState_v3_0.swift
//  Jewel
//
//  Created by Greg Hepworth on 21/04/2025.
//  Copyright © 2025 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct AppState_v3_0: Codable {
  
  static let versionKey = "jewelState_v3_0"
  
  var navigation = AppState_v3_0.Navigation()
  
  var settings: AppState_v3_0.Settings
  var library: AppState_v3_0.Library
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings = "options"
    case library
  }
  
  struct Navigation {
    
    var onRotationId: UUID?
    var activeStackId: UUID?
    var activeSlotIndex: Int = 0
    
    var onRotationActive: Bool {
      onRotationId == activeStackId
    }
    
    var selectedTab: Navigation.Tab = .onRotation {
      didSet {
        activeStackId = onRotationId
      }
    }
    enum Tab: String {
      case onRotation = "On Rotation"
      case library = "Stacks"
    }
    
    var showSearch: Bool = false
    
    var showAlbumDetail: Bool = false
    var showPlaybackLinks: Bool = false
    
    var gettingPlaybackLinks: Bool = false
    var gettingSearchResults: Bool = false
    
    var showStack: Bool = false
    var showStackOptions: Bool = false
    
    var showLibraryOptions: Bool = false
    
    var showSettings: Bool = false
    var showDebugMenu: Bool = false
    
    var libraryViewHeight: CGFloat = 812
    var stackCardHeight: CGFloat {
      cardHeightFor(libraryViewHeight)
    }
    
    var stackViewHeight: CGFloat = 812
    var albumCardHeight: CGFloat {
      cardHeightFor(stackViewHeight)
    }
    
    private func cardHeightFor(_ viewHeight: CGFloat) -> CGFloat {
      let height = (viewHeight - 200) / 8
      return height < 61 ? 61 : height
    }
    
  }
  
  struct Settings: Codable {
    var preferredMusicPlatform: OdesliPlatform = .appleMusic
    var firstTimeRun: Bool = true
  }
  
  struct Library: Codable {
    
    var onRotation: AppState_v3_0.Stack
    var stacks: [AppState_v3_0.Stack]
    
    enum CodingKeys: CodingKey {
      case onRotation
      case stacks
    }
  }
  
  struct Stack: Identifiable, Codable {
    var id = UUID()
    var name: String
    var slots: [AppState_v3_0.Slot] = {
      var tmpSlots = [AppState_v3_0.Slot]()
      for _ in 0..<8 {
        let slot = AppState_v3_0.Slot()
        tmpSlots.append(slot)
      }
      return tmpSlots
    }()
    
    enum CodingKeys: CodingKey {
      case id
      case name
      case slots
    }
  }
  
  struct Slot: Identifiable, Codable {
    var id = UUID()
    var album: Album?
    var playbackLinks: OdesliResponse?
    
    enum CodingKeys: String, CodingKey {
      case id
      case album = "source"
      case playbackLinks
    }
  }
  
}
