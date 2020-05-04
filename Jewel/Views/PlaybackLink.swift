//
//  PlaybackControlsView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
    
    var playbackUrl: URL
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(self.playbackUrl)
        }) {
        HStack {
            Image(systemName: "play.fill")
                .font(.headline)
            Text("Play in Apple Music")
                .font(.headline)
        }
        .padding()
        .foregroundColor(.black)
        .cornerRadius(40)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 2)
                .shadow(radius: 5)
            )
        }
    }
}

struct PlaybackControlsView_Previews: PreviewProvider {

    static var previews: some View {
        PlaybackLink(playbackUrl: URL(string: "https://music.apple.com/gb/album/based-on-a-true-story/1241281467")!)
    }
}
