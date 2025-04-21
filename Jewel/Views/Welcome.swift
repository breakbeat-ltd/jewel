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
  Stacks is a reminder and album curation app for your music.

  Add music to your On Rotation stack as a reminder to listen later.

  Save Stacks to curate sets of albums that represent a theme or time you don't want to forget.
  """
  private let startStackLabel = "Start Creating Stacks"
  
  var body: some View {
    RichAlert(heading: heading,
              buttons:
      Button {
        app.update(action: SettingsAction.firstTimeRun(false))
      } label: {
        Text(startStackLabel)
          .fontWeight(.bold)
      })
    {
      Text(description)
        .foregroundColor(Color.secondary)
    }
  }
}
