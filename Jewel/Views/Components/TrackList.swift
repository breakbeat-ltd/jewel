//
//  TrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct TrackList: View {
  
  let tracks: MusicItemCollection<Track>
  let albumArtistName: String
  
  private var songs: [Song] {
    var songs = [Song]()
    tracks.forEach { track in
      if case .song(let song) = track {
        songs.append(song)
      }
    }
    return songs
  }

  private var discCount: Int? {
    songs.map { $0.discNumber ?? 1 }.max()
  }

  var body: some View {
    VStack(alignment: .leading) {
      if let discCount = discCount {
        ForEach(1..<discCount + 1, id: \.self) { discNumber in
          DiscTrackList(
            discNumber: discNumber,
            discTracks: songs.filter { $0.discNumber == discNumber },
            showDiscNumber: (discCount > 1) ? true : false,
            albumArtistName: albumArtistName
          )
        }
      }
    }
  }
}
