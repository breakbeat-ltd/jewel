//
//  FontRegistrar.swift
//  Stacks
//
//  Created by Greg Hepworth on 15/04/2025.
//  Copyright © 2025 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

enum FontRegistrar {
  
  static func registerFont(name: String) {
    guard let asset = NSDataAsset(name: name),
          let provider = CGDataProvider(data: asset.data as NSData),
          let font = CGFont(provider) else {
      JewelLogger.runtime.error("💎 Runtime > Failed to load font from asset")
      return
    }
    
    var error: Unmanaged<CFError>?
    if !CTFontManagerRegisterGraphicsFont(font, &error) {
      let errorDescription = (error?.takeRetainedValue() as Error?)?.localizedDescription ?? "unknown error"
      JewelLogger.runtime.error("💎 Runtime > Failed to register font: \(errorDescription)")
    } else {
      JewelLogger.runtime.info("💎 Runtime > Font registered: \(font.postScriptName)")
    }
  }
  
}
