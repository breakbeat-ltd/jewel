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
