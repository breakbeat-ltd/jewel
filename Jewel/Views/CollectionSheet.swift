//
//  CollectionSheet.swift
//  Jewel
//
//  Created by Greg Hepworth on 25/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionSheet: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collection: Collection? {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      if let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == app.state.navigation.activeCollectionId }) {
        return app.state.library.collections[collectionIndex]
      }
      return nil
    }
  }
  
  var body: some View {
    NavigationView {
      if let collection = collection { // this if let has to be inside the NavigationView else the sheet isn't dismissed on removeCollection in CollectionOptions ¯\_(ツ)_/¯
        CollectionDetail(collection: collection)
          .navigationBarTitle("", displayMode: .inline)
          .navigationBarItems(
            leading:
              Button {
                app.update(action: NavigationAction.showCollection(false))
              } label: {
                Text("Close")
                  .font(.body)
              },
            trailing: CollectionActionButtons()
          )
          .navigationViewStyle(StackNavigationViewStyle())
      }
    }
  }
  
}
