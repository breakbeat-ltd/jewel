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
          StackActionButtons()
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

struct StackActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showStackOptions: Binding<Bool> { Binding (
    get: { app.state.navigation.showStackOptions },
    set: { if app.state.navigation.showStackOptions { app.update(action: NavigationAction.showStackOptions($0)) } }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        app.update(action: NavigationAction.showStackOptions(true))
      } label: {
        Text(Image(systemName: "ellipsis"))
          .font(.body)
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
      .padding(.leading)
      .sheet(isPresented: showStackOptions) {
        StackOptions()
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
        app.update(action: LibraryAction.createStack)
        app.update(action: NavigationAction.setActiveStackId(stackId: app.state.library.stacks.first!.id))
        app.update(action: NavigationAction.showStack(true))
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
