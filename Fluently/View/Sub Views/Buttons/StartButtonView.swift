//
//  StartButtonView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct StartButtonView: View {
    //: MARK: - Properties
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    //: MARK: - Body
    var body: some View {
        Button(action: {
            isOnboarding = false
        }) {
            HStack(spacing: 8) {
                Text("Start")
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

//: MARK: - Preview
struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView()
            .previewLayout(.sizeThatFits)
    }
}
