//
//  AlbumCard.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AlbumCard: View {
  
  let albumTitle: String
  let albumArtistName: String
  var albumArtwork: URL?
  
  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .background(
          AsyncImage(url: albumArtwork) { image in
            image
              .renderingMode(.original)
              .resizable()
              .scaledToFill()
          } placeholder: {
              ProgressView()
          }
      )
      .cornerRadius(Constants.cardCornerRadius)
      .overlay(
        VStack(alignment: .leading) {
          Text(albumTitle)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 4)
            .padding(.horizontal, 6)
            .lineLimit(1)
          Text(albumArtistName)
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
            .lineLimit(1)
        }
        .background(Color.black.opacity(0.8))
        .cornerRadius(Constants.cardCornerRadius)
        .padding(4)
        , alignment: .bottomLeading)
      .shadow(radius: 3)
  }
}
