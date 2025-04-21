//
//  SearchResults.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct SearchResults: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collectionId: UUID
  let slotIndex: Int
  
  private var searchResults: MusicItemCollection<Album>? {
    app.state.search.results
  }
  
  var body: some View {
    if let appleMusicAlbums = searchResults {
      List(0..<appleMusicAlbums.count, id: \.self) { i in
        let album = appleMusicAlbums[i]
        HStack {
          AsyncImage(url: album.artwork?.url(width: 50, height: 50)) { image in
            image
              .renderingMode(.original)
              .resizable()
              .aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
          }
          .cornerRadius(Constants.cardCornerRadius)
          .frame(width: 50)
          VStack(alignment: .leading) {
            Text(album.title)
              .font(.headline)
              .lineLimit(1)
            Text(album.artistName)
              .font(.subheadline)
              .lineLimit(1)
          }
          Spacer()
          Button {
            addAlbum(withId: album.id)
            app.update(action: SearchAction.removeSearchResults)
            app.update(action: NavigationAction.showSearch(false))
          } label: {
            Text(Image(systemName: "plus"))
              .padding()
              .foregroundColor(.secondary)
          }
        }
        
      }
    } else if app.state.navigation.gettingSearchResults {
      ProgressView()
    }
  }
  
  private func addAlbum(withId albumId: MusicItemID) {
    Task {
      async let album = RecordStore.getAlbum(withId: albumId)
      try? await app.update(action: LibraryAction.addAlbumToSlot(album: album, slotIndex: slotIndex, collectionId: collectionId))
      
      if let baseUrl = try? await album.url {
        app.update(action: NavigationAction.gettingPlaybackLinks(true))
        async let playbackLinks = RecordStore.getPlaybackLinks(for: baseUrl)
        try? app.update(action: LibraryAction.setPlaybackLinks(baseUrl: baseUrl, playbackLinks: await playbackLinks, collectionId: collectionId))
        app.update(action: NavigationAction.gettingPlaybackLinks(false))
      }
    }
  }
}
