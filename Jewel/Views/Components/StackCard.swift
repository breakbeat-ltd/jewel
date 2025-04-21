//
//  StackCard.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct StackCard: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let stack: Stack
  
  private var stackArtwork: [URL] {
    var artworkUrls = [URL]()
    for slot in stack.slots {
      if let artworkUrl = slot.album?.artwork?.url(width: 1000, height: 1000) {
        artworkUrls.append(artworkUrl)
      }
    }
    return artworkUrls
  }
  
  var body: some View {
    Button {
      app.update(action: NavigationAction.setActiveStackId(stackId: stack.id))
      app.update(action: NavigationAction.showStack(true))
    } label: {
      ZStack(alignment: .bottom) {
        Rectangle()
          .foregroundColor(.clear)
          .background(
            CardArtworkComposite(images: stackArtwork)
          )
          .cornerRadius(Constants.cardCornerRadius)
          .shadow(radius: 3)
        HStack(alignment: .bottom) {
          Text(stack.name)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .lineLimit(1)
            .background(Color.black.opacity(0.8))
            .cornerRadius(Constants.cardCornerRadius)
          Spacer()
        }
        .padding(4)
      }
    }
  }
}
