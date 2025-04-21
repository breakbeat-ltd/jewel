//
//  AppState_v2_0.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct AppState_v2_0: Codable {
  
  static let versionKey = "jewelState"
  
  var navigation = AppState_v2_0.Navigation()
  
  var settings: AppState_v2_0.Settings
  var library: AppState_v2_0.Library
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings = "options"
    case library
  }
  
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
      case library = "Collection Library"
    }
    
    var showSearch: Bool = false
    var showSharing: Bool = false
    var showLoadRecommendationsAlert: Bool = false
    
    var showAlbumDetail: Bool = false
    var showPlaybackLinks: Bool = false
    
    var gettingPlaybackLinks: Bool = false
    var gettingSearchResults: Bool = false
    
    var showCollection: Bool = false
    var showCollectionOptions: Bool = false
    
    var showLibraryOptions: Bool = false
    
    var shareLinkError = false
    
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
  
  struct Settings: Codable {
    var preferredMusicPlatform: Int = 0
    var firstTimeRun: Bool = true
  }
  
  struct Library: Codable {
    
    var onRotation: AppState_v2_0.Collection
    
    var collections: [AppState_v2_0.Collection]
    var cuedCollection: AppState_v2_0.Library.SharedCollectionManager.ShareableCollection?
    
    class SharedCollectionManager {
      
      struct ShareableCollection: Codable {
        let schemaName = "jewel-shared-collection"
        let schemaVersion: Decimal = 1.1
        let collectionName: String
        let collectionCurator: String
        let collection: [AppState_v2_0.Library.SharedCollectionManager.ShareableSlot?]
        
        enum CodingKeys: String, CodingKey {
          case schemaName = "sn"
          case schemaVersion = "sv"
          case collectionName = "cn"
          case collectionCurator = "cc"
          case collection = "c"
        }
      }
      
      struct ShareableSlot: Codable {
        let albumProvider: AppState_v2_0.Library.SharedCollectionManager.ShareableSlot.AlbumProvider
        let albumRef: String
        
        enum AlbumProvider: String, Codable {
          case appleMusicAlbum
        }
        
        enum CodingKeys: String, CodingKey {
          case albumProvider = "sp"
          case albumRef = "sr"
        }
      }
    }
  }
  
  struct Collection: Identifiable, Codable {
    var id = UUID()
    var type: AppState_v2_0.Collection.CollectionType
    var name: String
    var curator: String
    var slots: [AppState_v2_0.Slot] = {
      var tmpSlots = [AppState_v2_0.Slot]()
      for _ in 0..<8 {
        let slot = AppState_v2_0.Slot()
        tmpSlots.append(slot)
      }
      return tmpSlots
    }()
    
    var shareLinkLong: URL?
    var shareLinkShort: URL?
    
    enum CollectionType: String, Codable {
      case userCollection
      case sharedCollection
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
