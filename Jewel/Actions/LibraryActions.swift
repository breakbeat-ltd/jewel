//
//  LibraryActions.swift
//  Jewel
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

enum LibraryAction: AppAction {
  
  case setCollectionName(name: String, collectionId: UUID)
  case addAlbumToSlot(album: Album, slotIndex: Int, collectionId: UUID)
  case removeAlbumFromSlot(slotIndex: Int, collectionId: UUID)
  case setPlaybackLinks(baseUrl: URL, playbackLinks: OdesliResponse, collectionId: UUID)
  case saveOnRotation(collection: Collection)
  case createCollection
  case addCollection(collection: Collection)
  case duplicateCollection(collection: Collection)
  case removeCollection(collectionId: UUID)
  
  var description: String {
    switch self {
      
    case .setCollectionName(let name, _):
      return "\(type(of: self)): Setting user collection name to \(name)"
      
    case .addAlbumToSlot(let album, let slotIndex, let collectionId):
      return "\(type(of: self)): Adding AppleMusicAlbum \(album.id) to slot \(slotIndex) in collection \(collectionId)"
      
    case .removeAlbumFromSlot(let slotIndex, let collectionId):
      return "\(type(of: self)): Removing album in slot \(slotIndex) from collection \(collectionId)"
      
    case .setPlaybackLinks(let baseUrl, _, let collectionId):
      return "\(type(of: self)): Setting platform links for any album with \(baseUrl) in \(collectionId)"
      
    case .saveOnRotation:
      return "\(type(of: self)): Saving current On Rotation to Library"
      
    case .createCollection:
      return "\(type(of: self)): Creating a user collection in the Library"
      
    case .addCollection:
      return "\(type(of: self)): Adding a collection to the library"
      
    case .duplicateCollection(let collection):
      return "\(type(of: self)): Making a copy of collection \(collection.id)"
      
    case .removeCollection(let collectionId):
      return "\(type(of: self)): Removing collection \(collectionId) from the Library"
      
    }
  }
  
  func update(_ state: AppState) -> AppState {
    
    var newState = state
    
    func extractCollection(collectionId: UUID) -> Collection? {
      if newState.library.onRotation.id == collectionId {
        return newState.library.onRotation
      } else if let collectionIndex = newState.library.collections.firstIndex(where: { $0.id == collectionId }) {
        return newState.library.collections[collectionIndex]
      }
      return nil
    }
    
    func commitCollection(collection: Collection) {
      if collection.id == newState.library.onRotation.id {
        newState.library.onRotation = collection
      } else if let collectionIndex = newState.library.collections.firstIndex(where: { $0.id == collection.id }) {
        newState.library.collections[collectionIndex] = collection
      }
    }
    
    switch self {
      
    case let .setCollectionName(name, collectionId):
      if var collection = extractCollection(collectionId: collectionId) {
        collection.name = name
        commitCollection(collection: collection)
      }
      
    case let .addAlbumToSlot(album, slotIndex, collectionId):
      if var collection = extractCollection(collectionId: collectionId) {
        collection.slots[slotIndex].album = album
        commitCollection(collection: collection)
      }
      
    case let .removeAlbumFromSlot(slotIndex, collectionId):
      if var collection = extractCollection(collectionId: collectionId) {
        collection.slots[slotIndex] = Slot()
        commitCollection(collection: collection)
      }
      
    case let .saveOnRotation(collection):
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMM ''yy"
      let dateString = formatter.string(from: Date())
      var newCollection = collection
      newCollection.id = UUID()
      newCollection.name = "\(Navigation.Tab.onRotation.rawValue) (\(dateString))"
      newState.library.collections.insert(newCollection, at: 0)
      
    case .createCollection:
      let newCollection = Collection(name: "New Collection")
      newState.library.collections.insert(newCollection, at: 0)
      
    case let .addCollection(collection):
      newState.library.collections.insert(collection, at: 0)
      
    case let .duplicateCollection(collection):
      var duplicatedCollection = collection
      duplicatedCollection.id = UUID()
      duplicatedCollection.name = "Copy of \(collection.name)"
      newState.library.collections.insert(duplicatedCollection, at: 0)
      
    case let .removeCollection(collectionId):
      newState.library.collections.removeAll(where: { $0.id == collectionId })
      
    case let .setPlaybackLinks(baseUrl, playbackLinks, collectionId):
      if var collection = extractCollection(collectionId: collectionId) {
        let indices = collection.slots.enumerated().compactMap({ $1.album?.url == baseUrl ? $0 : nil })
        for i in indices {
          collection.slots[i].playbackLinks = playbackLinks
        }
        commitCollection(collection: collection)
      }
      
    }
    
    return newState
    
  }
  
}
