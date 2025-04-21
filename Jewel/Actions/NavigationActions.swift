//
//  NavigationActions.swift
//  Jewel
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI

enum NavigationAction: AppAction {
  
  case switchTab(to: Navigation.Tab)
  case setActiveCollectionId(collectionId: UUID)
  case setActiveSlotIndex(slotIndex: Int)
  case showSettings(Bool)
  case showSearch(Bool)
  case showCollection(Bool)
  case showCollectionOptions(Bool)
  case showLibraryOptions(Bool)
  case showAlbumDetail(Bool)
  case showPlaybackLinks(Bool)
  case gettingPlaybackLinks(Bool)
  case gettingSearchResults(Bool)
  case setCollectionViewHeight(viewHeight: CGFloat)
  case setLibraryViewHeight(viewHeight: CGFloat)
  case reset
  case toggleDebug
  
  var description: String {
    switch self {
    case .switchTab(let tab):
      return "\(type(of: self)): Switching to \(tab.rawValue) tab"
    case .setActiveCollectionId(let collectionId):
      return "\(type(of: self)): Setting active collection to \(collectionId)"
    case .setActiveSlotIndex(let slotId):
      return "\(type(of: self)): Setting active slot to \(slotId)"
    case .showSettings(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") settings"
    case .showSearch(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search"
    case .showCollection(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") collection"
    case .showCollectionOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") collection options"
    case .showLibraryOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") library options"
    case .showAlbumDetail(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") album detail"
    case .showPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") alternative links"
    case .gettingPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Hiding") playback links spinner"
    case .gettingSearchResults(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search spinner"
    case .setCollectionViewHeight(let height):
      return "\(type(of: self)): Setting collection view height to \(height)"
    case .setLibraryViewHeight(let height):
      return "\(type(of: self)): Setting library view height to \(height)"
    case .reset:
      return "\(type(of: self)): Resetting navigation to defaults"
    case .toggleDebug:
      return "\(type(of: self)): Toggling debug"
    }
  }
  
  func update(state: AppState) -> AppState {
    
    var newState = state
    
    switch self {
      
    case let .switchTab(toTab):
      newState.navigation.selectedTab = toTab
    
    case let .setActiveCollectionId(collectionId):
      newState.navigation.activeCollectionId = collectionId
      
    case let .setActiveSlotIndex(slotIndex):
      newState.navigation.activeSlotIndex = slotIndex
    
    case let .showSettings(showSettingsState):
      newState.navigation.showSettings = showSettingsState
      
    case let .showSearch(showSearchState):
      newState.navigation.showSearch = showSearchState

    case let .showCollection(showCollectionState):
      newState.navigation.showCollection = showCollectionState
    
    case let .showCollectionOptions(showCollectionOptionsState):
      newState.navigation.showCollectionOptions = showCollectionOptionsState
    
    case let .showLibraryOptions(showLibraryOptionsState):
      newState.navigation.showLibraryOptions = showLibraryOptionsState
      
    case let .showAlbumDetail(showAlbumDetailState):
      newState.navigation.showAlbumDetail = showAlbumDetailState
    
    case let .showPlaybackLinks(showPlaybackLinksState):
      newState.navigation.showPlaybackLinks = showPlaybackLinksState
    
    case let .gettingPlaybackLinks(gettingPlaybackLinksState):
      newState.navigation.gettingPlaybackLinks = gettingPlaybackLinksState
    
    case let .gettingSearchResults(gettingSearchResultsState):
      newState.navigation.gettingSearchResults = gettingSearchResultsState
      
    case let .setCollectionViewHeight(viewHeight):
      newState.navigation.collectionViewHeight = viewHeight
    
    case let .setLibraryViewHeight(viewHeight):
    newState.navigation.libraryViewHeight = viewHeight
    
    case .reset:
      newState.navigation = Navigation(onRotationId: newState.navigation.onRotationId, activeCollectionId: newState.navigation.activeCollectionId)
      
    case .toggleDebug:
      newState.navigation.showDebugMenu.toggle()
    
    }
    
    return newState
    
  }
  
}
