//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct StackOptions: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  private var stack: Stack? {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      return app.state.library.stacks.first(where: { $0.id == app.state.navigation.activeStackId })
    }
  }
  private var stackEmpty: Bool {
    stack?.slots.filter( { $0.album != nil }).count == 0
  }
  
  @State private var newStackName: String = ""
  @FocusState private var nameFocussed: Bool
  
  var body: some View {
    if let stack = stack { // this if has to be outside the NavigationView else LibraryAction.removeStack creates an exception ¯\_(ツ)_/¯
      NavigationView {
        Form {
          if !app.state.navigation.onRotationActive {
            Section {
              HStack {
                Text("Stack Name")
                  .font(.body)
                TextField(
                  stack.name,
                  text: $newStackName
                )
                .focused($nameFocussed)
                .onAppear {
                  self.newStackName = stack.name
                }
                .onChange(of: nameFocussed) {
                  if !newStackName.isEmpty && newStackName != stack.name {
                    app.update(action: LibraryAction.setStackName(name: newStackName.trimmingCharacters(in: .whitespaces), stackId: stack.id))
                  }
                }
                .font(.body)
                .foregroundColor(.accentColor)
              }
            }
          }
          Section {
            if app.state.navigation.onRotationActive {
              Button {
                app.update(action: NavigationAction.switchTab(to: .library))
                app.update(action: NavigationAction.showStackOptions(false))
                app.update(action: LibraryAction.saveOnRotation(stack: app.state.library.onRotation))
              } label: {
                HStack {
                  Text(Image(systemName: "arrow.right.square"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Save Stack")
                    .font(.body)
                }
              }
            } else {
              Button {
                app.update(action: LibraryAction.duplicateStack(stack: stack))
                app.update(action: NavigationAction.showStackOptions(false))
                app.update(action: NavigationAction.showStack(false))
              } label: {
                HStack {
                  Text(Image(systemName: "doc.on.doc"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Duplicate Stack")
                    .font(.body)
                }
              }
              Button {
                app.update(action: LibraryAction.removeStack(stackId: stack.id))
                app.update(action: NavigationAction.showStackOptions(false))
                app.update(action: NavigationAction.showStack(false))
              } label: {
                HStack {
                  Text(Image(systemName: "delete.left"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Delete Stack")
                    .font(.body)
                }
                .foregroundColor(stackEmpty ? nil : .red)
              }
            }
          }
          .disabled(stackEmpty)
        }
        .navigationBarTitle("\(app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Stack") Options", displayMode: .inline)
        .navigationBarItems(
          leading:
            Button {
              app.update(action: NavigationAction.showStackOptions(false))
            } label: {
              Text("Close")
                .font(.body)
            }
        )
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}
