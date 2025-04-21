//
//  Jewelheet.swift
//  Jewel
//
//  Created by Greg Hepworth on 25/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct StackSheet: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var stack: Stack? {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      if let stackIndex = app.state.library.stacks.firstIndex(where: { $0.id == app.state.navigation.activeStackId }) {
        return app.state.library.stacks[stackIndex]
      }
      return nil
    }
  }
  
  var body: some View {
    NavigationView {
      if let stack = stack { // this IfLet has to be inside the NavigationView else the sheet isn't dismissed on removeStack in StackOptions ¯\_(ツ)_/¯
        StackDetail(stack: stack)
          .navigationBarTitle("", displayMode: .inline)
          .navigationBarItems(
            leading:
              Button {
                app.update(action: NavigationAction.showStack(false))
              } label: {
                Text("Close")
                  .font(.body)
              },
            trailing: StackActionButtons()
          )
          .navigationViewStyle(StackNavigationViewStyle())
      }
    }
  }
  
}
