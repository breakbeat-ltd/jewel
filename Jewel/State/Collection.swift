//
//  Collection.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Collection: Identifiable, Codable {
  var id = UUID()
  var name: String
  var slots: [Slot] = {
    var tmpSlots = [Slot]()
    for _ in 0..<8 {
      let slot = Slot()
      tmpSlots.append(slot)
    }
    return tmpSlots
  }()
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case slots
  }
}
