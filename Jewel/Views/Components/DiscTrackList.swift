//
//  DiscTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct DiscTrackList: View {
  
  let discNumber: Int
  let discTracks: [Song]
  let showDiscNumber: Bool
  let albumArtistName: String
  
  var body: some View {
    VStack(alignment: .leading) {
      if showDiscNumber {
        Text("Disc \(discNumber)")
          .fontWeight(.bold)
          .padding(.vertical)
      }
      ForEach(discTracks) { song in
        HStack {
          Text(String(song.trackNumber ?? 0))
            .font(.footnote)
            .frame(width: 20, alignment: .center)
            .padding(.vertical)
            .padding(.trailing)
          VStack(alignment: .leading) {
            Text(song.title)
              .font(.callout)
              .fontWeight(.medium)
              .lineLimit(1)
            if song.artistName != albumArtistName {
              Text(song.artistName)
                .font(.callout)
                .fontWeight(.light)
                .opacity(0.7)
                .lineLimit(1)
            }
          }
          Spacer()
          if let duration = song.durationString {
            Text(duration)
              .font(.footnote)
              .opacity(0.7)
          }
        }
      }
    }
  }
}
