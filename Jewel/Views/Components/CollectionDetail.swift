//
//  CollectionDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 17/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionDetail: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment
  
  var collection: Collection

  private var showSheet: Binding<Bool> { Binding (
    get: { app.state.navigation.showAlbumDetail || app.state.navigation.showSearch },
    set: {
      if app.state.navigation.showAlbumDetail { app.update(action: NavigationAction.showAlbumDetail($0)) }
      if app.state.navigation.showSearch { app.update(action: NavigationAction.showSearch($0)) }
  }
    )}
  private var slots: [Slot] {
    collection.slots
  }
  private var collectionEmpty: Bool {
    collection.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    GeometryReader { geo in
      HStack {
        if horizontalSizeClass == .regular {
          Spacer()
        }
        ScrollView {
          Text(collection.name)
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
          ForEach(slots.indices, id: \.self) { slotIndex in
            Group {
              if slots[slotIndex].album != nil {
                if let album = slots[slotIndex].album {
                  Button {
                    app.update(action: NavigationAction.setActiveSlotIndex(slotIndex: slotIndex))
                    app.update(action: NavigationAction.showAlbumDetail(true))
                  } label: {
                    AlbumCard(albumTitle: album.title, albumArtistName: album.artistName, albumArtwork: album.artwork?.url(width: 1000, height: 1000))
                  }
                }
              } else {
                AddAlbumCardButton(slotIndex: slotIndex, collectionId: collection.id)
              }
            }
            .frame(height: app.state.navigation.albumCardHeight)
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: horizontalSizeClass == .regular && !app.state.navigation.showCollection ? Constants.regularMaxWidth : .infinity)
        if horizontalSizeClass == .regular {
          Spacer()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
      .sheet(isPresented: showSheet) {
        if app.state.navigation.showAlbumDetail {
          AlbumDetail()
            .environmentObject(app)
        } else if app.state.navigation.showSearch {
          SearchHome()
            .environmentObject(app)
        }
      }
      .onAppear {
        if geo.size.height != app.state.navigation.collectionViewHeight {
          app.update(action: NavigationAction.setCollectionViewHeight(viewHeight: geo.size.height))
        }
      }
      .onDisappear {
        if !app.state.navigation.onRotationActive && collectionEmpty {
          app.update(action: NavigationAction.setActiveCollectionId(collectionId: app.state.navigation.onRotationId!))
          app.update(action: LibraryAction.removeCollection(collectionId: collection.id))
        }
      }
    }
  }
}
