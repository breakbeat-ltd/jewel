//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AddAlbumCardButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let slotIndex: Int
  let collectionId: UUID
  
  var body: some View {
    Button {
      app.update(action: NavigationAction.setActiveCollectionId(collectionId: collectionId))
      app.update(action: NavigationAction.setActiveSlotIndex(slotIndex: slotIndex))
      app.update(action: NavigationAction.showSearch(true))
    } label: {
      RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
        .foregroundColor(Color(UIColor.secondarySystemBackground))
        .overlay(
          Text(Image(systemName: "plus"))
            .font(.headline)
            .foregroundColor(.secondary)
      )
    }
  }
}
