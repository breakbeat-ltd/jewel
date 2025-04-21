//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SearchHome: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  var body: some View {
    NavigationView {
      VStack{
        SearchBar()
        SearchResults(collectionId: app.state.navigation.activeCollectionId!, slotIndex: app.state.navigation.activeSlotIndex)
        Spacer()
      }
      .navigationBarTitle("Search")
      .navigationBarItems(
        leading:
        Button {
          app.update(action: NavigationAction.showSearch(false))
        } label: {
          Text("Close")
            .font(.body)
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onDisappear {
      app.update(action: SearchAction.removeSearchResults)
    }
  }
}
