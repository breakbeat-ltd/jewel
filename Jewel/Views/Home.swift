//
//  NewHome.swift
//  Jewel
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct Home: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.bottom)
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.top)
      VStack(spacing: 0) {
        NavBar()
        VStack {
          if app.state.navigation.selectedTab == .onRotation {
            OnRotation()
              .transition(.move(edge: .leading))
          }
          if app.state.navigation.selectedTab == .library {
            CollectionLibrary()
              .transition(.move(edge: .trailing))
          }
        }
        .background(Color(UIColor.systemBackground))
        .animation(.easeOut, value: app.state.navigation.selectedTab)
      }
      .disabled(app.state.settings.firstTimeRun)
      .blur(radius: app.state.settings.firstTimeRun ? 10 : 0)
      if app.state.settings.firstTimeRun {
        Welcome()
      }
    }
  }
}
