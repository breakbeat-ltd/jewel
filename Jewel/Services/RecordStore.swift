//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

enum RecordStoreError: Error {
  case NotFound(MusicItemID)
}

enum RecordStore {
  
  static func search(for searchTerm: String) async throws -> MusicItemCollection<Album> {
    JewelLogger.recordStore.info("💎 Record Store > Searching for '\(searchTerm)'")
    do {
      var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
      searchRequest.limit = 20
      return try await searchRequest.response().albums
    } catch {
      JewelLogger.recordStore.debug("💎 Record Store > Search error: \(String(describing: error))")
      throw error
    }
  }
  
  static func getAlbum(withId appleMusicAlbumId: MusicItemID) async throws -> Album {
    JewelLogger.recordStore.info("💎 Record Store > Getting Album with ID \(appleMusicAlbumId.rawValue)")
    do {
      var albumRequest = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: appleMusicAlbumId)
      albumRequest.properties = [.tracks]
      let albumResponse = try await albumRequest.response()
      
      guard let album = albumResponse.items.first else {
        JewelLogger.recordStore.info("💎 Record Store > Unable to find Album with ID \(appleMusicAlbumId)")
        throw RecordStoreError.NotFound(appleMusicAlbumId)
      }
      
      return album
      
    } catch {
      JewelLogger.recordStore.debug("💎 Record Store > Get album error: \(String(describing: error))")
      throw error
    }
  }
  
  static func getPlaybackLinks(for baseUrl: URL) async throws -> OdesliResponse {
    JewelLogger.recordStore.info("💎 Playback Links > Populating links for \(baseUrl.absoluteString)")
    do {
      let (data, response) = try await URLSession.shared.data(from: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!) as! (Data, HTTPURLResponse)
      
      if response.statusCode != 200 {
        JewelLogger.recordStore.debug("💎 Playback Links > Unexpected URL response code: \(response.statusCode)")
      }
      
      let playbackLinks = try JSONDecoder().decode(OdesliResponse.self, from: data)
      return playbackLinks
      
    } catch {
      JewelLogger.recordStore.debug("💎 Playback Links > Error getting playbackLinks: \(error.localizedDescription)")
      throw error
    }
  }
}
