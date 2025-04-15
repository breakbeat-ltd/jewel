//
//  Settings.swift
//  Stacks
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SettingsHome: View {
  
  @EnvironmentObject private var app: AppEnvironment

  private var preferredMusicPlatform: Binding<OdesliPlatform> { Binding (
    get: { app.state.settings.preferredMusicPlatform },
    set: { app.update(action: SettingsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker("Playback Service", selection: preferredMusicPlatform) {
              ForEach(OdesliPlatform.allCases) { platform in
                Text(String(describing: platform))
              }
            }
          }
          if app.state.navigation.showDebugMenu {
            Section(header: Text("Debug")) {
              Button {
                app.update(action: DebugAction.loadScreenshotState)
                app.update(action: NavigationAction.showSettings(false))
              } label: {
                Text("Load Screenshot Data")
              }
              Button {
                app.update(action: SettingsAction.reset)
              } label: {
                Text("Reset Jewel")
                  .foregroundColor(.red)
              }
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            app.update(action: NavigationAction.toggleDebug)
          }
          .padding()
      }
      .navigationBarTitle("Settings", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button {
          app.update(action: NavigationAction.showSettings(false))
        } label: {
          Text("Close")
            .font(.body)
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct SettingsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showSettings: Binding<Bool> { Binding (
    get: { app.state.navigation.showSettings },
    set: { if app.state.navigation.showSettings { app.update(action: NavigationAction.showSettings($0)) } }
  )}
  
  var body: some View {
    HStack {
      Button {
        app.update(action: NavigationAction.showSettings(true))
      } label: {
        Text(Image(systemName: "gear"))
          .font(.body)
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
      Spacer()
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
    .sheet(isPresented: showSettings) {
      SettingsHome()
        .environmentObject(app)
    }
  }
}

struct Footer: View {
  var body: some View {
    VStack {
      Text("🎵 + 📱 = 🙌")
        .padding(.bottom)
      Text("© 2025 Breakbeat Ltd.")
      Text(Bundle.main.buildNumber)
        .foregroundColor(Color.secondary)
    }
    .font(.footnote)
  }
}
