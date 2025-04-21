//
//  CollectionLibrary.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment

  private var showCollection: Binding<Bool> { Binding (
    get: { app.state.navigation.showCollection },
    set: { if app.state.navigation.showCollection { app.update(action: NavigationAction.showCollection($0)) } }
    )}
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    GeometryReader { geo in
      HStack {
        if horizontalSizeClass == .regular {
          Spacer()
        }
        ScrollView {
          Text("Collections")
            .font(.title)
            .fontWeight(.bold)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding(.top)
          if collections.isEmpty {
            VStack {
              Image(systemName: "music.note.list")
                .font(.system(size: 40))
                .padding(.bottom)
              Text("Collections you have saved or created will appear here.")
                .multilineTextAlignment(.center)
            }
            .padding()
            .foregroundColor(Color.secondary)
          } else {
            ForEach(collections) { collection in
              CollectionCard(collection: collection)
                .frame(height: app.state.navigation.collectionCardHeight)
            }
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: horizontalSizeClass == .regular ? Constants.regularMaxWidth : .infinity)
        if horizontalSizeClass == .regular {
          Spacer()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
      .sheet(isPresented: showCollection) {
        CollectionSheet()
          .environmentObject(app)
      }
      .onAppear {
        if geo.size.height != app.state.navigation.libraryViewHeight {
          app.update(action: NavigationAction.setLibraryViewHeight(viewHeight: geo.size.height))
        }
      }
    }
  }
}
