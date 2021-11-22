//
//  OnboardingView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        TabView {
            if isOnboarding == true {
                WelcomeCardView()
                SettingsCardView()
                CompletedCardView()
            } else {
                WelcomeCardView()
                SettingsCardView()
            }
            
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.top)
        .padding(.bottom)
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
