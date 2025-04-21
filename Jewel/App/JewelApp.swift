//
//  JewelApp.swift
//  Jewel
//
//  Created by Greg Hepworth on 27/09/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

@main
struct JewelApp: App {
  
  @State var appleMusicAuthorizationStatus = MusicAuthorization.currentStatus
  
  init() {
    FontRegistrar.registerFont(name: "FontAwesomeBrands")
  }
  
  var body: some Scene {
    WindowGroup {
      if appleMusicAuthorizationStatus != .authorized {
        AppleMusicAuthorization(appleMusicAuthorizationStatus: $appleMusicAuthorizationStatus)
      } else {
        Home()
          .environmentObject(AppEnvironment.global)
      }
    }
  }
  
}
