//
//  AppleMusicAuthorization.swift
//  Jewel
//
//  Created by Greg Hepworth on 07/11/2021.
//  Copyright © 2021 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct AppleMusicAuthorization: View {
  
  @Environment(\.openURL) private var openURL
  
  @Binding var appleMusicAuthorizationStatus: MusicAuthorization.Status
  
  var body: some View {
    VStack {
      Image("AppleMusicIcon")
        .resizable()
        .frame(width: 75, height: 75)
        .cornerRadius(5)
        .shadow(radius: 3)
        .padding(.bottom)
      Text(authorizationStatement)
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding([.horizontal, .bottom])
      if appleMusicAuthorizationStatus == .notDetermined || appleMusicAuthorizationStatus == .denied {
        if let action = action {
          Text(action.text)
            .foregroundColor(.secondary)
            .font(.title3)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .bottom])
          action.button
            .buttonStyle(.bordered)
        }
      }
    }
  }
  
  private var authorizationStatement: String {
    switch appleMusicAuthorizationStatus {
    case .restricted:
      return "Stacks cannot be used on this device because usage of Apple Music is restricted."
    default:
      return "Stacks uses the Apple Music catalogue to browse and save music."
    }
  }
  
  private var action: (text: String, button: Button<Text>)? {
    switch appleMusicAuthorizationStatus {
    case .notDetermined:
      return (
        "Please authorize access to Apple Music to continue.",
        Button {
          Task {
            appleMusicAuthorizationStatus = await MusicAuthorization.request()
          }
        } label: {
          Text("Authorize")
        }
      )
    case .denied:
      return (
        "Please allow access to Apple Music in Settings.",
        Button {
          if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            openURL(settingsURL)
          }
        } label: {
          Text("Open Settings")
        }
      )
    default:
      return nil
    }
  }
}
