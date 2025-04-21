//
//  CardArtworkComposite.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CardArtworkComposite: View {
  
  let images: [URL]
  
  var body: some View {
    HStack(spacing: 4) {
      if images.count != 0 {
        ForEach(images, id: \.self) { image in
          Rectangle()
            .foregroundColor(.clear)
            .background(
              AsyncImage(url: image) { image in
                image
                  .renderingMode(.original)
                  .resizable()
                  .scaledToFill()
              } placeholder: {
                  ProgressView()
              }
            )
            .clipped()
        }
      } else {
        Rectangle()
          .foregroundColor(Color(UIColor.secondarySystemBackground))
      }
      
    }
  }
}
