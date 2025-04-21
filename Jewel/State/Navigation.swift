//
//  Navigation.swift
//  Jewel
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct Navigation {
  
  var onRotationId: UUID?
  var activeCollectionId: UUID?
  var activeSlotIndex: Int = 0
  
  var onRotationActive: Bool {
    onRotationId == activeCollectionId
  }
  
  var selectedTab: Navigation.Tab = .onRotation {
    didSet {
      activeCollectionId = onRotationId
    }
  }
  enum Tab: String {
    case onRotation = "On Rotation"
    case library = "Collections"
  }
  
  var showSearch: Bool = false
  
  var showAlbumDetail: Bool = false
  var showPlaybackLinks: Bool = false
  
  var gettingPlaybackLinks: Bool = false
  var gettingSearchResults: Bool = false
  
  var showCollection: Bool = false
  var showCollectionOptions: Bool = false
  
  var showLibraryOptions: Bool = false
  
  var showSettings: Bool = false
  var showDebugMenu: Bool = false
  
  var libraryViewHeight: CGFloat = 812
  var collectionCardHeight: CGFloat {
    cardHeightFor(libraryViewHeight)
  }
  
  var collectionViewHeight: CGFloat = 812
  var albumCardHeight: CGFloat {
    cardHeightFor(collectionViewHeight)
  }
  
  private func cardHeightFor(_ viewHeight: CGFloat) -> CGFloat {
    let height = (viewHeight - 200) / 8
    return height < 61 ? 61 : height
  }
  
}
