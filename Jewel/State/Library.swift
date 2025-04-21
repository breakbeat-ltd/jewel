//
//  LibraryState.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Library: Codable {
  
  var onRotation: Collection
  var collections: [Collection]
  
  enum CodingKeys: CodingKey {
    case onRotation
    case collections
  }
}
