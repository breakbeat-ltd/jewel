//
//  StackLibrary.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct StackLibrary: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment

  private var showStack: Binding<Bool> { Binding (
    get: { app.state.navigation.showStack },
    set: { if app.state.navigation.showStack { app.update(action: NavigationAction.showStack($0)) } }
    )}
  
  private var stacks: [Stack] {
    app.state.library.stacks
  }
  
  var body: some View {
    GeometryReader { geo in
      HStack {
        if horizontalSizeClass == .regular {
          Spacer()
        }
        ScrollView {
          Text("Stacks")
            .font(.title)
            .fontWeight(.bold)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding(.top)
          if stacks.isEmpty {
            VStack {
              Image(systemName: "music.note.list")
                .font(.system(size: 40))
                .padding(.bottom)
              Text("Stacks you have saved or created will appear here.")
                .multilineTextAlignment(.center)
            }
            .padding()
            .foregroundColor(Color.secondary)
          } else {
            ForEach(stacks) { stack in
              StackCard(stack: stack)
                .frame(height: app.state.navigation.stackCardHeight)
            }
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: horizontalSizeClass == .regular ? Constants.regularMaxWidth : .infinity)
        if horizontalSizeClass == .regular {
          Spacer()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
      .sheet(isPresented: showStack) {
        StackSheet()
          .environmentObject(app)
      }
      .onAppear {
        if geo.size.height != app.state.navigation.libraryViewHeight {
          app.update(action: NavigationAction.setLibraryViewHeight(viewHeight: geo.size.height))
        }
      }
    }
  }
}
