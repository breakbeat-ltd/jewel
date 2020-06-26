//
//  NewHome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.app.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  private var overlayShowing: Bool {
    app.state.options.firstTimeRun || receivedCollectionCued.wrappedValue
  }
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.bottom)
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.top)
      VStack(spacing: 0) {
        NavBar()
        VStack {
          if app.navigation.selectedTab == .onRotation {
            OnRotation()
              .transition(.move(edge: .leading))
              .animation(.easeOut)
          }
          if app.navigation.selectedTab == .library {
            CollectionLibrary()
              .transition(.move(edge: .trailing))
              .animation(.easeOut)
          }
        }
        .background(Color(UIColor.systemBackground))
      }
      .disabled(overlayShowing)
      .blur(radius: overlayShowing ? 10 : 0)
      if app.state.options.firstTimeRun {
        Welcome()
      }
      if self.receivedCollectionCued.wrappedValue {
        CollectionReceived()
      }
    }
    .onAppear {
      UITableView.appearance().separatorStyle = .none
    }
  }
}
