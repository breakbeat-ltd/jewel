//
//  NewAlbumCover.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AlbumCover: View {
  
  let albumTitle: String
  let albumArtistName: String
  var albumArtwork: URL?
  
  var body: some View {
    VStack(alignment: .leading) {
        AsyncImage(url: albumArtwork) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(4)
        .shadow(radius: 4)
      Group {
        Text(albumTitle)
          .fontWeight(.bold)
        Text(albumArtistName)
      }
      .font(.title)
      .lineLimit(1)
    }
  }
}
