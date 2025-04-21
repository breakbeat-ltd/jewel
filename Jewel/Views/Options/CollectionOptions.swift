//
//  CollectionOptions.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionOptions: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  private var collection: Collection? {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      return app.state.library.collections.first(where: { $0.id == app.state.navigation.activeCollectionId })
    }
  }
  private var collectionEmpty: Bool {
    collection?.slots.filter( { $0.album != nil }).count == 0
  }
  
  @State private var newCollectionName: String = ""
  @FocusState private var nameFocussed: Bool
  
  var body: some View {
    if let collection = collection { // this if has to be outside the NavigationView else LibraryAction.removeCollection creates an exception ¯\_(ツ)_/¯
      NavigationView {
        Form {
          if !app.state.navigation.onRotationActive {
            Section {
              HStack {
                Text("Collection Name")
                  .font(.body)
                TextField(
                  collection.name,
                  text: $newCollectionName
                )
                .focused($nameFocussed)
                .onAppear {
                  self.newCollectionName = collection.name
                }
                .onChange(of: nameFocussed) {
                  if !newCollectionName.isEmpty && newCollectionName != collection.name {
                    app.update(action: LibraryAction.setCollectionName(name: newCollectionName.trimmingCharacters(in: .whitespaces), collectionId: collection.id))
                  }
                }
                .font(.body)
                .foregroundColor(.accentColor)
              }
            }
          }
          Section {
            if app.state.navigation.onRotationActive {
              Button {
                app.update(action: NavigationAction.switchTab(to: .library))
                app.update(action: NavigationAction.showCollectionOptions(false))
                app.update(action: LibraryAction.saveOnRotation(collection: app.state.library.onRotation))
              } label: {
                HStack {
                  Text(Image(systemName: "arrow.right.square"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Save Collection")
                    .font(.body)
                }
              }
            } else {
              Button {
                app.update(action: LibraryAction.duplicateCollection(collection: collection))
                app.update(action: NavigationAction.showCollectionOptions(false))
                app.update(action: NavigationAction.showCollection(false))
              } label: {
                HStack {
                  Text(Image(systemName: "doc.on.doc"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Duplicate Collection")
                    .font(.body)
                }
              }
              Button {
                app.update(action: LibraryAction.removeCollection(collectionId: collection.id))
                app.update(action: NavigationAction.showCollectionOptions(false))
                app.update(action: NavigationAction.showCollection(false))
              } label: {
                HStack {
                  Text(Image(systemName: "delete.left"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Delete Collection")
                    .font(.body)
                }
                .foregroundColor(collectionEmpty ? nil : .red)
              }
            }
          }
          .disabled(collectionEmpty)
        }
        .navigationBarTitle("\(app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection") Options", displayMode: .inline)
        .navigationBarItems(
          leading:
            Button {
              app.update(action: NavigationAction.showCollectionOptions(false))
            } label: {
              Text("Close")
                .font(.body)
            }
        )
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}
