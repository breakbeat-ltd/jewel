//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  private var collections: [Collection] {
    environment.state.library.collections
  }
  
  var body: some View {
    NavigationView {
      Group {
        if collections.count == 0 {
          Text("Collections you have saved or that people have shared with you will appear here.")
            .multilineTextAlignment(.center)
            .foregroundColor(Color.secondary)
            .padding()
        } else {
          List {
            ForEach(collections) { collection in
              NavigationLink(destination: CollectionDetail(collectionId: collection.id)) {
                CollectionCard(collection: collection)
              }
            }
            .onMove { (indexSet, index) in
              self.environment.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
            }
            .onDelete {
              self.environment.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
            }
          }
        }
      }
      .navigationBarTitle("Collection Library")
      .navigationBarItems(
        leading:
        HStack {
          collections.count != 0 ? AnyView(EditButton()) : AnyView(EmptyView())
        }
        .padding(.vertical),
        trailing:
        HStack {
          AddCollectionButton()
            .padding(.trailing)
          OptionsButton()
        }
        .padding(.vertical)
      )
    }
  }
}
