//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import UIKit

final class AppEnvironment: ObservableObject {
  
  static let global = AppEnvironment()
  
  @Published private(set) var state: AppState {
    didSet {
      StatePersitenceManager.save(state)
    }
  }
  
  private init() {
    state = StatePersitenceManager.load()
  }
  
  @MainActor public func update(action: AppAction) {
    state = action.update(state)
    JewelLogger.stateUpdate.info("💎 State Update > \(action.description)")
  }
  
}
