//
//  OptionsState.swift
//  Jewel
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Settings: Codable {
  var preferredMusicPlatform: OdesliPlatform = .appleMusic
  var firstTimeRun: Bool = true
}
