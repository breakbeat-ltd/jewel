//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct UserCollectionButtons: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  @State private var showLoadRecommendationsAlert = false
  
  private var collectionEmpty: Bool {
    store.state.library.userCollection.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    Group {
      if store.state.library.userCollectionActive {
        HStack {
          Button(action: {
            self.showOptions = true
          }) {
            Image(systemName: "slider.horizontal.3")
          }
          .sheet(isPresented: self.$showOptions) {
            OptionsHome(showing: self.$showOptions)
              .environmentObject(self.store)
          }
          .padding(.trailing)
          .padding(.vertical)
          Button(action: {
            self.showSharing = true
          }) {
            Image(systemName: "square.and.arrow.up")
          }
          .padding(.trailing)
          .padding(.vertical)
          .disabled(collectionEmpty)
          .actionSheet(isPresented: $showSharing) {
            ActionSheet(
              title: Text("Share this collection as \n \"\(store.state.library.userCollection.name)\" by \"\(store.state.library.userCollection.curator)\""),
              buttons: [
                .default(Text("Send Share Link")) {
                  self.showShareLink = true
                },
                .default(Text("Add to my Collection Library")) {
                  self.store.update(action: LibraryAction.addSharedCollection(collection: self.store.state.library.userCollection))
                  self.store.update(action: LibraryAction.userCollectionActive(false))
                },
                .cancel()
            ])
          }
          .sheet(isPresented: self.$showShareLink) {
            ShareSheetLoader()
              .environmentObject(self.store)
          }
        }
      } else {
        HStack {
          Button(action: {
            self.showLoadRecommendationsAlert = true
          }) {
            Image(systemName: "square.and.arrow.down")
          }
          .padding(.trailing)
          .padding(.vertical)
          .alert(isPresented: $showLoadRecommendationsAlert) {
            Alert(title: Text("Add our current Recommended Collection?"),
                  message: Text("Every three months we publish a Collection of new and classic albums for you to get into."),
                  primaryButton: .cancel(Text("Cancel")),
                  secondaryButton: .default(Text("Add").bold()) {
                    SharedCollectionManager.loadRecommendations()
              })
          }
          Button(action: {
            // this is a weird thing where I couldn't get this clause to align to the right places unless there was exactly the same layout as the other clause above
          }) {
            Image(systemName: "square.and.arrow.down")
              .opacity(0)
          }
          .padding(.trailing)
          .padding(.vertical)
          .disabled(true)
        }
      }
    }
  }
}

