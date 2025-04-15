//
//  JewelLogger.swift
//  Stacks
//
//  Created by Greg Hepworth on 15/04/2025.
//  Copyright © 2025 Breakbeat Ltd. All rights reserved.
//

import OSLog

struct JewelLogger {
  static let runtime = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "runtime")
  static let persistence = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "persistence")
  static let stateUpdate = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "stateUpdate")
  static let recordStore = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "recordStore")
  static let debugAction = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "debugAction")
}
