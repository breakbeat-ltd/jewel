//
//  Overlay.swift
//  Jewel
//
//  Created by Greg Hepworth on 26/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct RichAlert<Buttons: View, Content: View>: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  
  @EnvironmentObject var app: AppEnvironment

  let heading: String
  let buttons: Buttons
  let content: Content
  
  init(heading: String, buttons: Buttons, @ViewBuilder content: () -> Content) {
    self.heading = heading
    self.buttons = buttons
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geo in
      ZStack {
        Rectangle()
          .fill(Color(UIColor.secondarySystemBackground))
          .frame(width: responsiveWidth(viewWidth: geo.size.width), height: responsiveHeight(viewHeight: geo.size.height))
          .cornerRadius(20)
          .shadow(radius: 5)
        VStack(alignment: .leading, spacing: 0) {
          Text(heading)
            .font(.title)
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
          ZStack(alignment: .top) {
            GeometryReader { geo in
              ScrollView {
                content
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 5)
              }
              .padding(.horizontal)
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground), Color(UIColor.secondarySystemBackground).opacity(0)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 10)
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor.secondarySystemBackground).opacity(0), Color(UIColor.secondarySystemBackground)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 10)
                .offset(y: geo.size.height - 10)
            }
            
          }
          buttons
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
        }
        .frame(width: responsiveWidth(viewWidth: geo.size.width), height: responsiveHeight(viewHeight: geo.size.height))
        Image("PrimaryLogo")
          .resizable()
          .frame(width: 75, height: 75)
          .cornerRadius(5)
          .shadow(radius: 3)
          .offset(y: -(responsiveHeight(viewHeight: geo.size.height)/2))
      }
      .offset(
        x: (geo.size.width - responsiveWidth(viewWidth: geo.size.width)) / 2,
        y: (geo.size.height - responsiveHeight(viewHeight: geo.size.height)) / 2
      )
    }
  }
  
  private func responsiveWidth(viewWidth: CGFloat) -> CGFloat {
    if horizontalSizeClass == .compact {
      return viewWidth * 0.8
    } else {
      return 400
    }
  }
  
  private func responsiveHeight(viewHeight: CGFloat) -> CGFloat {
    if verticalSizeClass == .compact {
      return viewHeight - 85
    } else if horizontalSizeClass == .compact {
      return viewHeight * 0.55
    } else {
      return 500
    }
  }
  
}

struct RichAlert_Previews: PreviewProvider {
  static var previews: some View {
    RichAlert(
      heading: "Test Rich Alert",
      buttons:
        VStack {
          Button("Button 1") {}
          Divider()
            .padding(.bottom, 4)
          Button("Button 2") {}
        })
    {
      Text("Lorem Ipsum")
    }
  }
}
