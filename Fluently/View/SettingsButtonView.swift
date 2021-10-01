//
//  SettingsButtonView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct SettingsButtonView: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Text("Go To Settings")
                    .font(.system(.title2, design: .rounded))
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            .background(
                Capsule().strokeBorder(Color.black, lineWidth: 1.25))
        }//: BUTTON
        .accentColor(Color.black)
    }
}

struct SettingsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonView()
            .previewLayout(.sizeThatFits)
    }
}
