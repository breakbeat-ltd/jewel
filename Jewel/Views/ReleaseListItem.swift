//
//  Album.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct ReleaseListItem: View {
    
    var albumAttributes: AlbumAttributes
    
    var body: some View {
        Rectangle()
        .foregroundColor(.clear)
        .background(
            KFImage(albumAttributes.artwork.url(forWidth: 1000))
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
        )
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            ReleaseMetadataOverlay(
                title: albumAttributes.name,
                artist: albumAttributes.artistName
            ), alignment: .bottomLeading
        )
    }
}

struct Album_Previews: PreviewProvider {
    
    static let wallet = Wallet()
    
    static var previews: some View {
        ReleaseListItem(albumAttributes: (wallet.slots[0].album?.attributes!)!)
    }
}
