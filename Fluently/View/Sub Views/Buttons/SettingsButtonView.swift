//
//  SettingsButtonView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct SettingsButtonView: View {
    
    var body: some View {
        
        
        Button(action: { goToSettings() }) {
            HStack(spacing: 8) {
                Text("Go To Settings")
                    .font(.largeTitle)
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.black, lineWidth: 1.75))
        }//: BUTTON
        .accentColor(Color.black)
    }
}

//make a go to settings func here...

func goToSettings() {
    return
}



