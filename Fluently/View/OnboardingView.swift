//
//  OnboardingView.swift
//  Fluently
//
//  Created by Sawyer Cherry on 10/1/21.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            WelcomeCardView()
            SettingsCardView()
            CompletedCardView()
        }
        .tabViewStyle(.page)
        .padding(.top)
        .padding(.bottom)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
