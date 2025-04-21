//
//  NavBar.swift
//  Jewel
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct NavBar: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var selectedTab: Binding<Navigation.Tab> { Binding (
    get: { app.state.navigation.selectedTab },
    set: { app.update(action: NavigationAction.switchTab(to: $0))}
  )}
  
  var body: some View {
    VStack {
      HStack {
        SettingsButton()
        Spacer()
        Picker("Library", selection: selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onRotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 300)
        Spacer()
        if app.state.navigation.selectedTab == .onRotation {
          CollectionActionButtons()
        } else {
          LibraryActionButtons()
        }
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}

struct CollectionActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showCollectionOptions: Binding<Bool> { Binding (
    get: { app.state.navigation.showCollectionOptions },
    set: { if app.state.navigation.showCollectionOptions { app.update(action: NavigationAction.showCollectionOptions($0)) } }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        app.update(action: NavigationAction.showCollectionOptions(true))
      } label: {
        Text(Image(systemName: "ellipsis"))
          .font(.body)
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
      .padding(.leading)
      .sheet(isPresented: showCollectionOptions) {
        CollectionOptions()
          .environmentObject(app)
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}

struct LibraryActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        app.update(action: LibraryAction.createCollection)
        app.update(action: NavigationAction.setActiveCollectionId(collectionId: app.state.library.collections.first!.id))
        app.update(action: NavigationAction.showCollection(true))
      } label: {
        Text(Image(systemName: "plus"))
          .font(.body)
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
