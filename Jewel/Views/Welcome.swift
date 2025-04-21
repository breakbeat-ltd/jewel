//
//  Welcome.swift
//  Jewel
//
//  Created by Greg Hepworth on 09/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Welcome: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private let heading = "Welcome!"
  private let description = """
  Listen Later is a reminder and album curation app for your music.

  Add music to your On Rotation collection as a reminder to listen later.

  Save Collections to curate sets of albums that represent a theme or time you don't want to forget.
  """
  private let startCollectionLabel = "Start Creating Collections"
  
  var body: some View {
    RichAlert(heading: heading,
              buttons:
      Button {
        app.update(action: SettingsAction.firstTimeRun(false))
      } label: {
        Text(startCollectionLabel)
          .fontWeight(.bold)
      })
    {
      Text(description)
        .foregroundColor(Color.secondary)
    }
  }
}
