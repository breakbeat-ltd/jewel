//
//  OnRotation.swift
//  Jewel
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OnRotation: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    StackDetail(stack: app.state.library.onRotation)
  }
}
